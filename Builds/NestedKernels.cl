__kernel void MatCmp(
  __global uchar* ABackgroundBmp,
  __global uchar* ASubBmp,
  __global int* AResultedErrCount,
  __global uchar* AKernelDone,
  const unsigned int ABackgroundWidth,
  const unsigned int ASubBmpWidth,
  const unsigned int ASubBmpHeight,
  const unsigned int AXOffset,
  const unsigned int AYOffset,
  const uchar AColorError,
  const long ASlaveQueue) //Without passing SlaveQueue to this kernel, it seems that the variable is optimized out in main kernel, and cannot be used properly.
{
  int YIdx = get_global_id(0);
  //int YIdx = get_local_id(0);
  __global uchar const * BGRow = &ABackgroundBmp[((YIdx + AYOffset) * ABackgroundWidth + AXOffset) * 3];
  __global uchar const * SubRow = &ASubBmp[(YIdx * ASubBmpWidth) * 3];
  int ErrCount = 0;
  for (int x = 0; x < ASubBmpWidth; x++)
  {                                             
     int x0_BG = x * 3 + 0;
     int x1_BG = x * 3 + 1;
     int x2_BG = x * 3 + 2;
     int x0_Sub = x * 3 + 0;
     int x1_Sub = x * 3 + 1;
     int x2_Sub = x * 3 + 2;
     short SubPxB = SubRow[x0_Sub];
     short BGPxB = BGRow[x0_BG];
     short SubPxG = SubRow[x1_Sub];
     short BGPxG = BGRow[x1_BG];
     short SubPxR = SubRow[x2_Sub];
     short BGPxR = BGRow[x2_BG];
     if ((abs(SubPxR - BGPxR) > AColorError) ||
         (abs(SubPxG - BGPxG) > AColorError) ||
         (abs(SubPxB - BGPxB) > AColorError))
     {
       ErrCount++;
     }  //if
  }  //for
  AResultedErrCount[YIdx] = ErrCount;
  //AResultedErrCount[YIdx] = get_work_dim();  //Uncomment, to get the value of get_work_dim on a slave kernel.
  AKernelDone[YIdx] = 1;
}
                                           
__kernel void SlideSearch(
  __global uchar* ABackgroundBmp,
  __global uchar* ASubBmp,
  __global int* AResultedErrCount,
  __global int* ADebuggingInfo,
  __global uchar* AKernelDone,
  const unsigned int ABackgroundWidth,
  const unsigned int ASubBmpWidth,
  const unsigned int ASubBmpHeight,
  const unsigned int AXOffset,
  const unsigned int AYOffset,
  const uchar AColorError,
  const long ASlaveQueue,
  const unsigned int ATotalErrorCount)
{
  queue_t SlaveQueue = (queue_t)ASlaveQueue; //get_default_queue() requies OpenCL >= 2.0 and __opencl_c_device_enqueue    (so... it may not be available)
  clk_event_t AllKernelsEvent;
  clk_event_t FinalEvent;

  ndrange_t ndrange = ndrange_1D(1, ASubBmpHeight); //defined as ndrange_1D(global, local)
  kernel_enqueue_flags_t MyFlags;
  MyFlags = CLK_ENQUEUE_FLAGS_NO_WAIT;
  int i, j, k = 0;
  bool Found = false;
  bool AllKernelsDone;
  int EnqKrnErr = -1234;
  int EnqMrkErr = -4567;
  int XOffset = AXOffset;
  int YOffset = AYOffset;
  int DifferentCount = 0;
  for (i = 0; i < YOffset; i++)
  {
    for (j = 0; j < XOffset; j++)
    {
      for (k = 0; k < ASubBmpHeight; k++)
        AKernelDone[k] = 0;

      EnqKrnErr = enqueue_kernel(
        SlaveQueue,
        MyFlags,
        ndrange,
        0,                //comment for err -10
        NULL,             //comment for err -10
        &AllKernelsEvent, //comment for err -10
        ^{MatCmp(ABackgroundBmp, ASubBmp, AResultedErrCount, AKernelDone, ABackgroundWidth, ASubBmpWidth, ASubBmpHeight, j, i, AColorError, SlaveQueue);});

        //wait for all kernels to be done
        AllKernelsDone = false;
        while (!AllKernelsDone)
        {
          AllKernelsDone = true;
          for (k = 0; k < ASubBmpHeight; k++)
            if (AKernelDone[k] == 0)
            {
              AllKernelsDone = false;
              break;
            }
          //it would be nice to have a sleep call here
        } //while


      ADebuggingInfo[0] = EnqKrnErr;

      EnqMrkErr = enqueue_marker(SlaveQueue, 1, AllKernelsEvent, &FinalEvent);
      ADebuggingInfo[1] = EnqMrkErr;

      release_event(AllKernelsEvent); //should be called here, right after enqueue_marker?
      release_event(FinalEvent);      //should be called here, right after enqueue_marker?

      DifferentCount = 0;
      for (k = 0; k < ASubBmpHeight; k++)
        DifferentCount += AResultedErrCount[k];

      int TotalErrorCount = ATotalErrorCount;
      if (DifferentCount < TotalErrorCount)
      {
        Found = true;
        break;
      }

      if (EnqKrnErr < 0)
      {
        break;
      }
    }  //for j

    if (Found || EnqKrnErr < 0)
      break;
  }  // for i

  ADebuggingInfo[2] = i;
  ADebuggingInfo[3] = j;
  ADebuggingInfo[4] = DifferentCount;
  ADebuggingInfo[5] = (int)Found;
  ADebuggingInfo[6] = get_work_dim();
  ADebuggingInfo[7] = get_global_size(1);
  ADebuggingInfo[8] = get_local_size(1);
  ADebuggingInfo[9] = get_enqueued_local_size(1);
  ADebuggingInfo[10] = ATotalErrorCount;
  release_event(AllKernelsEvent);
  release_event(FinalEvent);
} //func
