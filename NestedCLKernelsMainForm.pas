{
    Copyright (C) 2025 VCC
    creation date: 19 Mar 2025
    initial release date: 21 Mar 2025

    author: VCC
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"),
    to deal in the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:
    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
    DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
    OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
}


unit NestedCLKernelsMainForm;

{$mode objfpc}{$H+}
//{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, Spin;

type
  TCLDeviceArr = TStringArray;
  TAllCLDevicesArr = array of TCLDeviceArr; //all devices from all platforms

  { TfrmNestedCLKernelsMain }

  TfrmNestedCLKernelsMain = class(TForm)
    btnBrowseOpenCL: TButton;
    btnReloadPlatformInfo: TButton;
    btnBrowseKernelCode: TButton;
    btnLoadKernelFile: TButton;
    btnSaveKernelFile: TButton;
    chkUseMinusG: TCheckBox;
    chkUseKernelArgInfo: TCheckBox;
    lblTotalErrorCount: TLabel;
    lblModified: TLabel;
    lblOptions: TLabel;
    lbeKernelCode: TLabeledEdit;
    lbeOpenCLPath: TLabeledEdit;
    lblSrcBmpWidth: TLabel;
    lblSrcBmpHeight: TLabel;
    lblSubBmpHeight1: TLabel;
    lblSubBmpWidth: TLabel;
    lblSubBmpHeight: TLabel;
    lblSubBmpXPos: TLabel;
    lblColorErrorLevel: TLabel;
    memCode: TMemo;
    memLog: TMemo;
    OpenDialog1: TOpenDialog;
    OpenDialog2: TOpenDialog;
    rdgrpPlatforms: TRadioGroup;
    rdgrpDevices: TRadioGroup;
    spdbtnRunKernelOnDevice: TSpeedButton;
    spnedtTotalErrorCount: TSpinEdit;
    spnedtSubBmpHeight: TSpinEdit;
    spnedtSrcBmpWidth: TSpinEdit;
    spnedtSrcBmpHeight: TSpinEdit;
    spnedtColorErrorLevel: TSpinEdit;
    spnedtSubBmpYPos: TSpinEdit;
    spnedtSubBmpWidth: TSpinEdit;
    spnedtSubBmpXPos: TSpinEdit;
    tmrPlatformSelection: TTimer;
    tmrStartup: TTimer;
    procedure btnBrowseKernelCodeClick(Sender: TObject);
    procedure btnBrowseOpenCLClick(Sender: TObject);
    procedure btnLoadKernelFileClick(Sender: TObject);
    procedure btnReloadPlatformInfoClick(Sender: TObject);
    procedure memCodeChange(Sender: TObject);
    procedure memCodeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure spdbtnRunKernelOnDeviceClick(Sender: TObject);
    procedure btnSaveKernelFileClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure rdgrpPlatformsClick(Sender: TObject);
    procedure tmrPlatformSelectionTimer(Sender: TObject);
    procedure tmrStartupTimer(Sender: TObject);
  private
    FAllCLDevices: TAllCLDevicesArr;

    procedure AddToLog(s: string);
    procedure GetOpenCLInfo;
    procedure LoadKernelFileIntoEditor;
    procedure SaveKernelFile;
    procedure RunKernelOnDevice(APlatformIndex, ADeviceIndex: Integer;
                                ASrcBmpData, ASubBmpData: Pointer;
                                ABytesPerPixelOnSrc, ABytesPerPixelOnSub: Integer;
                                ASourceBitmapWidth, ASourceBitmapHeight, ASubBitmapWidth, ASubBitmapHeight: Integer;
                                AColorErrorLevel, ATotalErrorCount: Integer);

    procedure LoadSettingsFromIni;
    procedure SaveSettingsToIni;
  public

  end;

var
  frmNestedCLKernelsMain: TfrmNestedCLKernelsMain;


{ToDo:
- N:
}

implementation

{$R *.frm}

uses
  IniFiles, CLHeaders, ctypes;

{ TfrmNestedCLKernelsMain }

procedure TfrmNestedCLKernelsMain.FormCreate(Sender: TObject);
begin
  SetLength(FAllCLDevices, 0);
  tmrStartup.Enabled := True;
end;


procedure TfrmNestedCLKernelsMain.LoadSettingsFromIni;
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(ExtractFilePath(ParamStr(0)) + 'NestedCLKernels.ini');
  try
    Left := Ini.ReadInteger('Window', 'Left', Left);
    Top := Ini.ReadInteger('Window', 'Top', Top);
    Width := Ini.ReadInteger('Window', 'Width', Width);
    Height := Ini.ReadInteger('Window', 'Height', Height);

    lbeOpenCLPath.Text := Ini.ReadString('Settings', 'OpenCLPath', lbeOpenCLPath.Text);
    lbeKernelCode.Text := Ini.ReadString('Settings', 'KernelCode', lbeKernelCode.Text);
    chkUseMinusG.Checked := Ini.ReadBool('Settings', 'UseMinusG', chkUseMinusG.Checked);
    chkUseKernelArgInfo.Checked := Ini.ReadBool('Settings', 'UseKernelArgInfo', chkUseKernelArgInfo.Checked);

    spnedtSrcBmpWidth.Value := Ini.ReadInteger('Settings', 'SrcBmpWidth', spnedtSrcBmpWidth.Value);
    spnedtSrcBmpHeight.Value := Ini.ReadInteger('Settings', 'SrcBmpHeight', spnedtSrcBmpHeight.Value);
    spnedtSubBmpWidth.Value := Ini.ReadInteger('Settings', 'SubBmpWidth', spnedtSubBmpWidth.Value);
    spnedtSubBmpHeight.Value := Ini.ReadInteger('Settings', 'SubBmpWidth', spnedtSubBmpHeight.Value);
    spnedtSubBmpXPos.Value := Ini.ReadInteger('Settings', 'SubBmpXPos', spnedtSubBmpXPos.Value);
    spnedtSubBmpYPos.Value := Ini.ReadInteger('Settings', 'SubBmpYPos', spnedtSubBmpYPos.Value);
    spnedtColorErrorLevel.Value := Ini.ReadInteger('Settings', 'ColorErrorLevel', spnedtColorErrorLevel.Value);
    spnedtTotalErrorCount.Value := Ini.ReadInteger('Settings', 'TotalErrorCount', spnedtTotalErrorCount.Value);
  finally
    Ini.Free;
  end;
end;


procedure TfrmNestedCLKernelsMain.SaveSettingsToIni;
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(ExtractFilePath(ParamStr(0)) + 'NestedCLKernels.ini');
  try
    Ini.WriteInteger('Window', 'Left', Left);
    Ini.WriteInteger('Window', 'Top', Top);
    Ini.WriteInteger('Window', 'Width', Width);
    Ini.WriteInteger('Window', 'Height', Height);

    Ini.WriteString('Settings', 'OpenCLPath', lbeOpenCLPath.Text);
    Ini.WriteString('Settings', 'KernelCode', lbeKernelCode.Text);
    Ini.WriteBool('Settings', 'UseMinusG', chkUseMinusG.Checked);
    Ini.WriteBool('Settings', 'UseKernelArgInfo', chkUseKernelArgInfo.Checked);

    Ini.WriteInteger('Settings', 'SrcBmpWidth', spnedtSrcBmpWidth.Value);
    Ini.WriteInteger('Settings', 'SrcBmpHeight', spnedtSrcBmpHeight.Value);
    Ini.WriteInteger('Settings', 'SubBmpWidth', spnedtSubBmpWidth.Value);
    Ini.WriteInteger('Settings', 'SubBmpWidth', spnedtSubBmpHeight.Value);
    Ini.WriteInteger('Settings', 'SubBmpXPos', spnedtSubBmpXPos.Value);
    Ini.WriteInteger('Settings', 'SubBmpYPos', spnedtSubBmpYPos.Value);
    Ini.WriteInteger('Settings', 'ColorErrorLevel', spnedtColorErrorLevel.Value);
    Ini.WriteInteger('Settings', 'TotalErrorCount', spnedtTotalErrorCount.Value);

    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
end;


procedure TfrmNestedCLKernelsMain.rdgrpPlatformsClick(Sender: TObject);
begin
  tmrPlatformSelection.Enabled := True;
end;


procedure TfrmNestedCLKernelsMain.tmrPlatformSelectionTimer(Sender: TObject);
var
  j: Integer;
begin
  tmrPlatformSelection.Enabled := False;

  rdgrpDevices.Items.Clear;
  if rdgrpPlatforms.ItemIndex = -1 then
    Exit;

  for j := 0 to Length(FAllCLDevices[rdgrpPlatforms.ItemIndex]) - 1 do
    rdgrpDevices.Items.Add(FAllCLDevices[rdgrpPlatforms.ItemIndex][j]);

  if rdgrpDevices.ItemIndex = -1 then
    if rdgrpDevices.Items.Count > 0 then
      rdgrpDevices.ItemIndex := 0;
end;


procedure TfrmNestedCLKernelsMain.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
var
  i: Integer;
begin
  try
    for i := 0 to Length(FAllCLDevices) - 1 do
      SetLength(FAllCLDevices[i], 0);

    SetLength(FAllCLDevices, 0);
  except
  end;

  try
    SaveSettingsToIni;
  except
  end;
end;


procedure TfrmNestedCLKernelsMain.LoadKernelFileIntoEditor;
var
  KernelFilePath: string;
begin
  KernelFilePath := StringReplace(lbeKernelCode.Text, '$AppDir$', ExtractFileDir(ParamStr(0)), [rfReplaceAll]);

  {$IFnDEF Windows}
    KernelFilePath := StringReplace(KernelFilePath, '\', '/', [rfReplaceAll]);
  {$ENDIF}

  if not FileExists(KernelFilePath) then
  begin
    MessageDlg(Application.Title, 'File not found:' + #13#10 + KernelFilePath, mtError, [mbOK], '');
    Exit;
  end;

  memCode.Lines.LoadFromFile(KernelFilePath);
  lblModified.Hide;
end;


procedure TfrmNestedCLKernelsMain.SaveKernelFile;
var
  KernelFilePath: string;
begin
  KernelFilePath := StringReplace(lbeKernelCode.Text, '$AppDir$', ExtractFileDir(ParamStr(0)), [rfReplaceAll]);
  memCode.Lines.SaveToFile(KernelFilePath);
  lblModified.Hide;
end;


procedure TfrmNestedCLKernelsMain.btnBrowseOpenCLClick(Sender: TObject);
begin
  OpenDialog1.InitialDir := ExtractFileDir(lbeOpenCLPath.Text);
  if not OpenDialog1.Execute then
    Exit;

  lbeOpenCLPath.Text := OpenDialog1.FileName;
end;


procedure TfrmNestedCLKernelsMain.btnLoadKernelFileClick(Sender: TObject);
begin
  if memCode.Lines.Count > 0 then
    if MessageDlg(Application.Title, 'Are you sure you want to reload the file into editor?', mtInformation, [mbYes, mbNo], '') = mrNo then
      Exit;

  LoadKernelFileIntoEditor;
end;


procedure TfrmNestedCLKernelsMain.btnBrowseKernelCodeClick(Sender: TObject);
begin
  OpenDialog2.InitialDir := ExtractFileDir(lbeKernelCode.Text);
  if not OpenDialog2.Execute then
    Exit;

  lbeKernelCode.Text := OpenDialog2.FileName;
  lbeKernelCode.Text := StringReplace(lbeKernelCode.Text, ExtractFileDir(ParamStr(0)), '$AppDir$', [rfReplaceAll]);
end;


procedure TfrmNestedCLKernelsMain.btnReloadPlatformInfoClick(Sender: TObject);
begin
  GetOpenCLInfo;
end;


procedure TfrmNestedCLKernelsMain.memCodeChange(Sender: TObject);
begin
  lblModified.Show;
end;


procedure TfrmNestedCLKernelsMain.memCodeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = Ord('S') then
    if ssCtrl in Shift then
      btnSaveKernelFile.Click;
end;


const
  CDevType: array[0..1] of Integer = (CL_DEVICE_TYPE_GPU, CL_DEVICE_TYPE_CPU);


procedure TfrmNestedCLKernelsMain.RunKernelOnDevice(APlatformIndex, ADeviceIndex: Integer;
                                                    ASrcBmpData, ASubBmpData: Pointer;
                                                    ABytesPerPixelOnSrc, ABytesPerPixelOnSub: Integer;
                                                    ASourceBitmapWidth, ASourceBitmapHeight, ASubBitmapWidth, ASubBitmapHeight: Integer;
                                                    AColorErrorLevel, ATotalErrorCount: Integer);
var
  OpenCLDll: TOpenCL;
  KernelSrc: string;

  Error, SecondError: Integer;
  DiffCntPerRow, DbgBuffer: array of LongInt;

  DevType: cl_device_type; //GPU
  PlatformIDs: Pcl_platform_id;
  PlatformCount, DeviceCount: cl_uint;
  GlobalSize, GlobalSizeWithDeviceEnqueue: csize_t;
  LocalSize: csize_t;
  DeviceIDs: Pcl_device_id;
  Context: cl_context;
  CmdQueue, SlaveCmdQueue: cl_command_queue;
  CLProgram: cl_program;
  CLKernel: cl_kernel;

  i, j: Integer;
  BackgroundBmpWidth, BackgroundBmpHeight: Integer;
  SubBmpWidth, SubBmpHeight: Integer;
  XOffset, YOffset: Integer;
  ColorError: Byte;

  BackgroundBufferRef: cl_mem;
  SubBufferRef: cl_mem;
  ResBufferRef: cl_mem;
  DbgBufferRef: cl_mem;
  KernelDoneBufferRef: cl_mem;

  BuildOptions: string;
  Info: string;
  InfoLen: csize_t;
  QueueProperties: array[0..8] of cl_command_queue_properties;

  procedure LogCallResult(AError: Integer; AFuncName, AInfo: string; AExtraErrorInfo: string = '');
  var
    Msg: string;
  begin
    if AError = 0 then
      Exit;

    while Pos(#0, AExtraErrorInfo) > 0 do
    begin
      Delete(AExtraErrorInfo, Pos(#0, AExtraErrorInfo), 1);
      if Length(AExtraErrorInfo) = 0 then
        Break;
    end;

    if Pos(#0, AInfo) > 0 then
      Delete(AInfo, Pos(#0, AInfo), 1);

    Msg := 'Error ' + CLErrorToStr(AError) + ' " at "' + AFuncName + '" OpenCL API call.  ' + AExtraErrorInfo;
    if AInfo <> '' then
      Msg := Msg + '  Expected: ' + AInfo;

    raise Exception.Create(Msg);
  end;
begin
  AddToLog('');
  AddToLog('Src bmp size: ' + IntToStr(ASourceBitmapWidth) + ' : ' + IntToStr(ASourceBitmapHeight));
  AddToLog('Sub bmp size: ' + IntToStr(ASubBitmapWidth) + ' : ' + IntToStr(ASubBitmapHeight));
  AddToLog('BytesPerPixelOnSub: ' + IntToStr(ABytesPerPixelOnSub));
  AddToLog('BytesPerPixelOnSrc: ' + IntToStr(ABytesPerPixelOnSrc));
  AddToLog('AColorErrorLevel: ' + IntToStr(AColorErrorLevel));

  if APlatformIndex = -1 then
  begin
    AddToLog('No platform selected. Exiting.');
    Exit;
  end;

  if ADeviceIndex = -1 then
  begin
    AddToLog('No device selected. Exiting.');
    Exit;
  end;

  BackgroundBmpWidth := ASourceBitmapWidth;
  BackgroundBmpHeight := ASourceBitmapHeight;
  SubBmpWidth := ASubBitmapWidth;
  SubBmpHeight := ASubBitmapHeight;

  OpenCLDll := TOpenCL.Create;
  try
    if OpenCLDll.ExpectedDllLocation <> lbeOpenCLPath.Text then
    begin
      OpenCLDll.ExpectedDllFileName := ExtractFileName(lbeOpenCLPath.Text);
      OpenCLDll.ExpectedDllDir := ExtractFileDir(lbeOpenCLPath.Text);
      OpenCLDll.LoadOpenCLLibrary;
    end;

    if not OpenCLDll.Loaded then
      raise Exception.Create('OpenCL not available. The dll is expected to exist at ' + OpenCLDll.ExpectedDllLocation);

    AddToLog('Running kernel...');
    KernelSrc := memCode.Lines.Text;

    Error := OpenCLDll.clGetPlatformIDs(0, nil, @PlatformCount);
    LogCallResult(Error, 'clGetPlatformIDs', 'PlatformCount: ' + IntToStr(PlatformCount));

    GetMem(PlatformIDs, PlatformCount * SizeOf(cl_platform_id));
    try
      Error := OpenCLDll.clGetPlatformIDs(PlatformCount, PlatformIDs, nil);
      LogCallResult(Error, 'clGetPlatformIDs', '');

      DevType := CL_DEVICE_TYPE_GPU;
      Error := OpenCLDll.clGetDeviceIDs(PlatformIDs[APlatformIndex], DevType, 0, nil, @DeviceCount);
      LogCallResult(Error, 'clGetDeviceIDs', 'DeviceCount: ' + IntToStr(DeviceCount));


      GetMem(DeviceIDs, DeviceCount * SizeOf(cl_device_id));
      try
        Error := OpenCLDll.clGetDeviceIDs(PlatformIDs[APlatformIndex], DevType, DeviceCount, DeviceIDs, nil);
        LogCallResult(Error, 'clGetDeviceIDs', '');

        Context := OpenCLDll.clCreateContext(nil, 1, @DeviceIDs[ADeviceIndex], nil, nil, Error);
        try
          if Context = nil then
            LogCallResult(Error, 'clCreateContext', '', 'Error is ' + IntToStr(Error));

          QueueProperties[0] := CL_QUEUE_PROPERTIES;
          QueueProperties[1] := CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE;
          QueueProperties[2] := 0;

          try
            CmdQueue := OpenCLDll.clCreateCommandQueueWithProperties(Context, DeviceIDs[ADeviceIndex], @QueueProperties, Error);
            if (CmdQueue = nil) or (Error <> 0) then
              LogCallResult(Error, 'clCreateCommandQueueWithProperties CmdQueue', '');
          except
            on E: Exception do
              LogCallResult(Error, 'clCreateCommandQueueWithProperties CmdQueue', '', 'Ex: ' + E.Message);
          end;

          QueueProperties[0] := CL_QUEUE_PROPERTIES;
          QueueProperties[1] := CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE or CL_QUEUE_ON_DEVICE or CL_QUEUE_ON_DEVICE_DEFAULT;
          QueueProperties[2] := 0;

          try
            SlaveCmdQueue := OpenCLDll.clCreateCommandQueueWithProperties(Context, DeviceIDs[ADeviceIndex], @QueueProperties, Error);  //also tested by creating this queue before the other one.  get_default_queue  still returns 0.
            if (SlaveCmdQueue = nil) or (Error <> 0) then
              LogCallResult(Error, 'clCreateCommandQueueWithProperties SlaveCmdQueue', '');
          except
            on E: Exception do
              LogCallResult(Error, 'clCreateCommandQueueWithProperties SlaveCmdQueue', '', 'Ex: ' + E.Message);
          end;

          try
            CLProgram := OpenCLDll.clCreateProgramWithSource(Context, 1, PPAnsiChar(@KernelSrc), nil, Error);
            try
              if CLProgram = nil then
                LogCallResult(Error, 'clCreateProgramWithSource', '');

              BuildOptions := '';
              if chkUseMinusG.Checked then
                BuildOptions := '-g';

              if chkUseKernelArgInfo.Checked then
              begin
                if BuildOptions <> '' then  //has -g
                  BuildOptions := BuildOptions + ' ';

                BuildOptions := BuildOptions + '-cl-kernel-arg-info';  //used for getting additional debugging info from enqueue_kernel.
              end;

              Error := OpenCLDll.clBuildProgram(CLProgram, 0, nil, @BuildOptions[1], nil, nil);
              //LogCallResult(Error, 'clBuildProgram', 'Kernel code compiled.');  //commented, to allow the next call to clGetProgramBuildInfo

              if Error < CL_SUCCESS then
              begin
                SetLength(Info, 32768);
                SecondError := OpenCLDll.clGetProgramBuildInfo(CLProgram, DeviceIDs[ADeviceIndex], CL_PROGRAM_BUILD_LOG, Length(Info), @Info[1], InfoLen);
                SetLength(Info, InfoLen);
                LogCallResult(SecondError, 'clGetProgramBuildInfo', 'Additional build info.');

                Info := StringReplace(Info, #13#10, '|', [rfReplaceAll]);
                Info := StringReplace(Info, #10, '|', [rfReplaceAll]);
                LogCallResult(Error, 'clBuildProgram', 'Kernel code compiled.', Info);
              end;

              CLKernel := OpenCLDll.clCreateKernel(CLProgram, 'SlideSearch', Error);  //CLKernel := clCreateKernel(CLProgram, 'MatCmp', Error);
              try
                LogCallResult(Error, 'clCreateKernel', 'Kernel allocated.');

                Error := OpenCLDll.clGetKernelWorkGroupInfo(CLKernel, DeviceIDs[ADeviceIndex], CL_KERNEL_WORK_GROUP_SIZE, SizeOf(LocalSize), @LocalSize, InfoLen);
                LogCallResult(Error, 'clGetKernelWorkGroupInfo', 'Work group info obtained.');

                BackgroundBufferRef := OpenCLDll.clCreateBuffer(Context, CL_MEM_READ_ONLY, csize_t(ABytesPerPixelOnSrc * BackgroundBmpWidth * BackgroundBmpHeight), nil, Error);
                try
                  LogCallResult(Error, 'clCreateBuffer', 'Background buffer created.');

                  SubBufferRef := OpenCLDll.clCreateBuffer(Context, CL_MEM_READ_ONLY, csize_t(ABytesPerPixelOnSub * SubBmpWidth * SubBmpHeight), nil, Error);
                  try
                    LogCallResult(Error, 'clCreateBuffer', 'Sub buffer created.');

                    ResBufferRef := OpenCLDll.clCreateBuffer(Context, CL_MEM_WRITE_ONLY, csize_t(SizeOf(LongInt) * SubBmpHeight), nil, Error);
                    try
                      LogCallResult(Error, 'clCreateBuffer', 'Res buffer created.');

                      SetLength(DbgBuffer, 20);
                      DbgBufferRef := OpenCLDll.clCreateBuffer(Context, CL_MEM_WRITE_ONLY, csize_t(SizeOf(LongInt) * Length(DbgBuffer)), nil, Error); //10 items
                      try
                        LogCallResult(Error, 'clCreateBuffer', 'Dbg buffer created.');

                        KernelDoneBufferRef := OpenCLDll.clCreateBuffer(Context, CL_MEM_WRITE_ONLY, csize_t(SubBmpHeight), nil, Error);
                        try
                          LogCallResult(Error, 'clCreateBuffer', 'KernelDoneBufferRef buffer created.');

                          Error := OpenCLDll.clEnqueueWriteBuffer(CmdQueue, BackgroundBufferRef, CL_TRUE, 0, csize_t(ABytesPerPixelOnSrc * BackgroundBmpWidth * BackgroundBmpHeight), ASrcBmpData, 0, nil, nil);
                          LogCallResult(Error, 'clEnqueueWriteBuffer', 'Background buffer written.');

                          Error := OpenCLDll.clEnqueueWriteBuffer(CmdQueue, SubBufferRef, CL_TRUE, 0, csize_t(ABytesPerPixelOnSub * SubBmpWidth * SubBmpHeight), ASubBmpData, 0, nil, nil);
                          LogCallResult(Error, 'clEnqueueWriteBuffer', 'Sub buffer written.');

                          XOffset := 0;
                          YOffset := 0;
                          ColorError := AColorErrorLevel;


                          Error := OpenCLDll.clSetKernelArg(CLKernel, 0, SizeOf(cl_mem), @BackgroundBufferRef); //sizeof(cl_mem)  is SizeOf(Pointer), which can be 4 or 8
                          LogCallResult(Error, 'clSetKernelArg', 'BackgroundBufferRef argument set.');

                          Error := OpenCLDll.clSetKernelArg(CLKernel, 1, SizeOf(cl_mem), @SubBufferRef); //sizeof(cl_mem)  is SizeOf(Pointer), which can be 4 or 8
                          LogCallResult(Error, 'clSetKernelArg', 'SubBufferRef argument set.');

                          Error := OpenCLDll.clSetKernelArg(CLKernel, 2, SizeOf(cl_mem), @ResBufferRef); //sizeof(cl_mem)  is SizeOf(Pointer), which can be 4 or 8
                          LogCallResult(Error, 'clSetKernelArg', 'ResBufferRef argument set.');

                          Error := OpenCLDll.clSetKernelArg(CLKernel, 3, SizeOf(cl_mem), @DbgBufferRef); //sizeof(cl_mem)  is SizeOf(Pointer), which can be 4 or 8
                          LogCallResult(Error, 'clSetKernelArg', 'DbgBufferRef argument set.');

                          Error := OpenCLDll.clSetKernelArg(CLKernel, 4, SizeOf(cl_mem), @KernelDoneBufferRef); //sizeof(cl_mem)  is SizeOf(Pointer), which can be 4 or 8
                          LogCallResult(Error, 'clSetKernelArg', 'KernelDoneBufferRef argument set.');

                          Error := OpenCLDll.clSetKernelArg(CLKernel, 5, SizeOf(LongInt), @BackgroundBmpWidth);
                          LogCallResult(Error, 'clSetKernelArg', 'ABackgroundWidth argument set.');

                          Error := OpenCLDll.clSetKernelArg(CLKernel, 6, SizeOf(LongInt), @SubBmpWidth);
                          LogCallResult(Error, 'clSetKernelArg', 'ASubBmpWidth argument set.');

                          Error := OpenCLDll.clSetKernelArg(CLKernel, 7, SizeOf(LongInt), @SubBmpHeight);
                          LogCallResult(Error, 'clSetKernelArg', 'SubBmpHeight argument set.');

                          XOffset := BackgroundBmpWidth - SubBmpWidth - 1;
                          Error := OpenCLDll.clSetKernelArg(CLKernel, 8, SizeOf(LongInt), @XOffset);
                          LogCallResult(Error, 'clSetKernelArg', 'XOffset argument set.');

                          YOffset := BackgroundBmpHeight - SubBmpHeight - 1;
                          Error := OpenCLDll.clSetKernelArg(CLKernel, 9, SizeOf(LongInt), @YOffset);
                          LogCallResult(Error, 'clSetKernelArg', 'YOffset argument set.');

                          Error := OpenCLDll.clSetKernelArg(CLKernel, 10, SizeOf(Byte), @ColorError);
                          LogCallResult(Error, 'clSetKernelArg', 'ColorError argument set.');

                          Error := OpenCLDll.clSetKernelArg(CLKernel, 11, SizeOf(cl_ulong), @SlaveCmdQueue);  //using SizeOf(cl_ulong), because the parameter is a QWord on kernel
                          LogCallResult(Error, 'clSetKernelArg', 'SlaveCmdQueue argument set.');  //This was plain SlaveCmdQueue, instead of @SlaveCmdQueue.

                          Error := OpenCLDll.clSetKernelArg(CLKernel, 12, SizeOf(ATotalErrorCount), @ATotalErrorCount);
                          LogCallResult(Error, 'clSetKernelArg', 'TotalErrorCount argument set.');

                          GlobalSize := SubBmpHeight;
                          LogCallResult(Error, 'Matrix comparison', 'Starting...');

                          GlobalSizeWithDeviceEnqueue := 1; //one master kernel, although not sure if Local should be 1
                          Error := OpenCLDll.clEnqueueNDRangeKernel(CmdQueue, CLKernel, 1, nil, @GlobalSizeWithDeviceEnqueue, nil, 0, nil, nil);
                          LogCallResult(Error, 'clEnqueueNDRangeKernel CmdQueue', '');

                          Error := OpenCLDll.clFinish(CmdQueue);     //see also ResBufferRef := OpenCLDll.clCreateBuffer  - the buffer is created to items longer
                          LogCallResult(Error, 'clFinish CmdQueue (Before clEnqueueReadBuffer)', '');
                          SetLength(DiffCntPerRow, GlobalSize);
                          Error := OpenCLDll.clEnqueueReadBuffer(CmdQueue, ResBufferRef, CL_TRUE, 0, csize_t(SizeOf(LongInt) * Length(DiffCntPerRow)), @DiffCntPerRow[0], 0, nil, nil);
                          LogCallResult(Error, 'clEnqueueReadBuffer DiffCntPerRow', '', '  kernel enqueue err is DiffCntPerRow[Len-2] = ' + IntToStr(DiffCntPerRow[Length(DiffCntPerRow) - 2]) + '  kernel get_default_queue is DiffCntPerRow[Len-1] = ' + IntToStr(DiffCntPerRow[Length(DiffCntPerRow) - 1]) + '  Length(DiffCntPerRow) = ' + IntToStr(Length(DiffCntPerRow)));

                          AddToLog('ErrCount:' + #13#10 +
                                   '  ResultedErrCount[0] = ' + IntToStr(DiffCntPerRow[0]) + #13#10 +
                                   '  ResultedErrCount[1] = ' + IntToStr(DiffCntPerRow[1]) + #13#10 +
                                   '  ResultedErrCount[2] = ' + IntToStr(DiffCntPerRow[2]) + #13#10 +
                                   '  ResultedErrCount[n - 4] = ' + IntToStr(DiffCntPerRow[Length(DiffCntPerRow) - 4]) + #13#10 +
                                   '  ResultedErrCount[n - 3] = ' + IntToStr(DiffCntPerRow[Length(DiffCntPerRow) - 3]) + #13#10 +
                                   '  ResultedErrCount[n - 2] = ' + IntToStr(DiffCntPerRow[Length(DiffCntPerRow) - 2]) + #13#10 +
                                   '  ResultedErrCount[n - 1] = ' + IntToStr(DiffCntPerRow[Length(DiffCntPerRow) - 1]));

                          FillChar(DbgBuffer[0], Length(DbgBuffer), SizeOf(DbgBuffer[0]));
                          Error := OpenCLDll.clEnqueueReadBuffer(CmdQueue, DbgBufferRef, CL_TRUE, 0, csize_t(SizeOf(LongInt) * Length(DbgBuffer)), @DbgBuffer[0], 0, nil, nil);
                          LogCallResult(Error, 'clEnqueueReadBuffer DbgBuffer', '', '  kernel enqueue err is ' + IntToStr(DbgBuffer[0]) + '  kernel enqueue_marker is ' + IntToStr(DiffCntPerRow[1]) + '  Length(DbgBuffer) = ' + IntToStr(Length(DbgBuffer)) + '  i = ' + IntToStr(i) + '  j = ' + IntToStr(j));

                          AddToLog('Misc info:' + #13#10 +
                                   '  enqueue_kernel = ' + IntToStr(DbgBuffer[0]) + #13#10 +
                                   '  enqueue_marker = ' + IntToStr(DbgBuffer[1]) + #13#10 +
                                   '  i = ' + IntToStr(DbgBuffer[2]) + #13#10 +
                                   '  j = ' + IntToStr(DbgBuffer[3]) + #13#10 +
                                   '  DifferentCount = ' + IntToStr(DbgBuffer[4]) + #13#10 +
                                   '  Found = ' + IntToStr(DbgBuffer[5]) + #13#10 +
                                   '  get_work_dim on "SlideSearch" = ' + IntToStr(DbgBuffer[6]) + #13#10 +
                                   '  get_global_size on "SlideSearch" = ' + IntToStr(DbgBuffer[7]) + #13#10 +
                                   '  get_local_size on "SlideSearch" = ' + IntToStr(DbgBuffer[8]) + #13#10 +
                                   '  get_enqueued_local_size on "SlideSearch" = ' + IntToStr(DbgBuffer[9]) + #13#10 +
                                   '  TotalErrorCount = ' + IntToStr(DbgBuffer[10]) + #13#10 +
                                   '  DbgBuffer[11] = ' + IntToStr(DbgBuffer[11]) + #13#10 +
                                   '  DbgBuffer[12] = ' + IntToStr(DbgBuffer[12]) + #13#10 +
                                   '  DbgBuffer[13] = ' + IntToStr(DbgBuffer[13]) + #13#10 +
                                   '  DbgBuffer[14] = ' + IntToStr(DbgBuffer[14]) + #13#10 +
                                   '  DbgBuffer[15] = ' + IntToStr(DbgBuffer[15]) + #13#10 +
                                   '  DbgBuffer[16] = ' + IntToStr(DbgBuffer[16]) + #13#10 +
                                   '  DbgBuffer[17] = ' + IntToStr(DbgBuffer[17]) + #13#10 +
                                   '  DbgBuffer[18] = ' + IntToStr(DbgBuffer[18]) + #13#10 +
                                   '  DbgBuffer[19] = ' + IntToStr(DbgBuffer[19]) + #13#10
                                  );

                          //Error := OpenCLDll.clFinish(SlaveCmdQueue);                     //CL_INVALID_COMMAND_QUEUE if command_queue is not a valid host command-queue.
                          //LogCallResult(Error, 'clFinish SlaveCmdQueue', '');
                        finally
                          OpenCLDll.clReleaseMemObject(KernelDoneBufferRef);
                        end;
                      finally
                        OpenCLDll.clReleaseMemObject(DbgBufferRef);
                      end;
                    finally
                      OpenCLDll.clReleaseMemObject(ResBufferRef);
                    end;
                  finally
                    OpenCLDll.clReleaseMemObject(SubBufferRef);
                  end;
                finally
                  OpenCLDll.clReleaseMemObject(BackgroundBufferRef);
                end;
              finally  //clCreateKernel
                OpenCLDll.clReleaseKernel(CLKernel);
              end;
            finally
              OpenCLDll.clReleaseProgram(CLProgram);
            end;
          finally
            OpenCLDll.clReleaseCommandQueue(CmdQueue);
            OpenCLDll.clReleaseCommandQueue(SlaveCmdQueue);
          end;
        finally
          OpenCLDll.clReleaseContext(Context);
        end;
      finally
        Freemem(DeviceIDs, DeviceCount * SizeOf(cl_device_id));
      end;
    finally
      Freemem(PlatformIDs, PlatformCount * SizeOf(cl_platform_id));
    end;
  finally
    OpenCLDll.Free;
  end;
end;


procedure DrawWipeRect(ACanvas: TCanvas; NewWidth, NewHeight: Integer);
begin
  ACanvas.Lock;
  try
    ACanvas.Brush.Style := bsSolid;
    ACanvas.Brush.Color := clWhite;
    ACanvas.Pen.Color := clWhite;
    ACanvas.Rectangle(0, 0, NewWidth {- 1}, NewHeight {- 1});
  finally
    ACanvas.Unlock
  end;
end;


procedure WipeBitmap(ABitmap: TBitmap; NewWidth, NewHeight: Integer);
begin
  //ABitmap.Clear;
  ABitmap.SetSize(NewWidth, NewHeight);
  DrawWipeRect(ABitmap.Canvas, NewWidth, NewHeight);
end;


procedure TfrmNestedCLKernelsMain.spdbtnRunKernelOnDeviceClick(Sender: TObject);
var
  SourceStream, SubStream: TMemoryStream;
  i: Integer;
  BytesPerPixelSrc, BytesPerPixelSub: Integer;
  ScLn: Pointer;

  SourceBitmap, SubBitmap: TBitmap;
  ColorErrorLevel, TotalErrorCount: Integer;
begin
  try
    try
      SourceBitmap := TBitmap.Create;
      SubBitmap := TBitmap.Create;
      SourceStream := TMemoryStream.Create;
      SubStream := TMemoryStream.Create;
      try
        WipeBitmap(SourceBitmap, spnedtSrcBmpWidth.Value, spnedtSrcBmpHeight.Value);
        WipeBitmap(SubBitmap, spnedtSubBmpWidth.Value, spnedtSubBmpHeight.Value);

        SourceBitmap.Canvas.Font.Color := clBlack;
        SourceBitmap.Canvas.TextOut(spnedtSubBmpXPos.Value, spnedtSubBmpYPos.Value, 'abc');
        SubBitmap.Canvas.Font.Color := clBlack;
        SubBitmap.Canvas.TextOut(0, 0, 'abc');
        ColorErrorLevel := spnedtColorErrorLevel.Value;
        TotalErrorCount := spnedtTotalErrorCount.Value;

        if SourceBitmap.PixelFormat = pf24bit then
          BytesPerPixelSrc := 3
        else
          BytesPerPixelSrc := 4;

        if SubBitmap.PixelFormat = pf24bit then
          BytesPerPixelSub := 3
        else
          BytesPerPixelSub := 4;

        for i := 0 to SourceBitmap.Height - 1 do
        begin
          ScLn := SourceBitmap.{%H-}ScanLine[i];
          SourceStream.Write(ScLn^, SourceBitmap.Width * BytesPerPixelSrc);
        end;

        for i := 0 to SubBitmap.Height - 1 do
        begin
          ScLn := SubBitmap.{%H-}ScanLine[i];
          SubStream.Write(ScLn^, SubBitmap.Width * BytesPerPixelSub);
        end;

        RunKernelOnDevice(rdgrpPlatforms.ItemIndex,
                          rdgrpDevices.ItemIndex,
                          SourceStream.Memory,
                          SubStream.Memory,
                          BytesPerPixelSrc,
                          BytesPerPixelSub,
                          SourceBitmap.Width,
                          SourceBitmap.Height,
                          SubBitmap.Width,
                          SubBitmap.Height,
                          ColorErrorLevel,
                          TotalErrorCount);
      finally
        SourceStream.Free;
        SubStream.Free;
        SourceBitmap.Free;
        SubBitmap.Free;
      end;
    except
      on E: Exception do
        AddToLog(E.Message);
    end;
  finally
    AddToLog('Done running kernel.');
  end;
end;


procedure TfrmNestedCLKernelsMain.btnSaveKernelFileClick(Sender: TObject);
begin
  SaveKernelFile;
end;


procedure TfrmNestedCLKernelsMain.AddToLog(s: string);
var
  i: Integer;
  ListOfItems: TStringList;
begin
  if Pos('|', s) = 0 then
    memLog.Lines.Add(DateTimeToStr(Now) + '  ' + s)
  else
  begin
    ListOfItems := TStringList.Create;
    try
      ListOfItems.Text := StringReplace(s, '|', #13#10, [rfReplaceAll]);

      for i := 0 to ListOfItems.Count - 1 do
        memLog.Lines.Add(DateTimeToStr(Now) + '  ' + ListOfItems.Strings[i]);
    finally
      ListOfItems.Free;
    end;
  end;
end;


procedure TfrmNestedCLKernelsMain.GetOpenCLInfo;
var
  OpenCLDll: TOpenCL;

  function LogCallResult(AError: Integer; AFuncName, AInfo: string): string;
  begin
    Result := 'Error ' + CLErrorToStr(AError) + ' at "' + AFuncName + '" OpenCL API call. ' + AInfo;
  end;

  function GetPlatformInfo(APlatform: cl_platform_id; APlatformParamName: cl_platform_info; APlatformParamNameStr: string): string;
  var
    InfoLen: csize_t;
    Info: string;
    Error: Integer;
  begin
    SetLength(Info, 32768);
    Error := OpenCLDll.clGetPlatformInfo(APlatform, APlatformParamName, csize_t(Length(Info)), @Info[1], InfoLen);

    if Error < 0 then
    begin
      Result := LogCallResult(Error, 'clGetPlatformInfo(' + APlatformParamNameStr + ')', '');
      Exit;
    end;

    SetLength(Info, InfoLen - 1);  // -1, to avoid copying the null byte
    Result := Info;
  end;

  function GetPlatformInfoStr(APlatformIndex: Integer; APlatform: cl_platform_id; APlatformParamName: cl_platform_info; APlatformParamNameStr: string): string;
  begin
    Result := APlatformParamNameStr + '[' + IntToStr(APlatformIndex) + ']: ' + GetPlatformInfo(APlatform, APlatformParamName, APlatformParamNameStr);
  end;

  function GetDeviceInfo(ADevice: cl_Device_id; ADeviceParamName: cl_device_info; ADeviceParamNameStr: string; ACLParamIsInt: Boolean = False): string;
  var
    InfoLen: csize_t;
    Info: string;
    Error: Integer;
  begin
    SetLength(Info, 32768);

    try
      Error := OpenCLDll.clGetDeviceInfo(ADevice, ADeviceParamName, csize_t(Length(Info)), @Info[1], InfoLen);
    except
      on E: Exception do
      begin
        Result := 'Ex: ' + E.Message + ' at ' + ADeviceParamNameStr;
        Exit;
      end;
    end;

    if Error < 0 then
    begin
      Result := LogCallResult(Error, 'clGetDeviceInfo(' + ADeviceParamNameStr + ')', '');
      Exit;
    end;

    SetLength(Info, InfoLen - 1); // -1, to avoid copying the null byte

    if ACLParamIsInt then
      Info := IntToStr(PDWord(@Info[1])^);

    Result := Info;
  end;

  function GetDeviceInfoStr(APlatformIndex, ADeviceIndex: Integer; ADevice: cl_Device_id; ADeviceParamName: cl_device_info; ADeviceParamNameStr: string; ACLParamIsInt: Boolean = False): string;
  begin
    Result := ADeviceParamNameStr + '[' + IntToStr(APlatformIndex) + ', ' + IntToStr(ADeviceIndex) + ']: ' + GetDeviceInfo(ADevice, ADeviceParamName, ADeviceParamNameStr, ACLParamIsInt);
  end;

var
  Error: Integer;
  PlatformCount, DeviceCount: cl_uint;
  PlatformIDs: Pcl_platform_id;
  DeviceIDs: Pcl_device_id;
  i, j: Integer;
begin
  OpenCLDll := TOpenCL.Create;
  try
    if OpenCLDll.ExpectedDllLocation <> lbeOpenCLPath.Text then
    begin
      OpenCLDll.ExpectedDllFileName := ExtractFileName(lbeOpenCLPath.Text);
      OpenCLDll.ExpectedDllDir := ExtractFileDir(lbeOpenCLPath.Text);
      OpenCLDll.LoadOpenCLLibrary;
    end;

    if not OpenCLDll.Loaded then
    begin
      AddToLog('OpenCL not available. The dll is expected to exist at ' + OpenCLDll.ExpectedDllLocation);
      Exit;
    end;

    Error := OpenCLDll.clGetPlatformIDs(0, nil, @PlatformCount);
    LogCallResult(Error, 'clGetPlatformIDs', 'PlatformCount: ' + IntToStr(PlatformCount));
    AddToLog('');
    AddToLog('PlatformCount: ' + IntToStr(PlatformCount));

    SetLength(FAllCLDevices, PlatformCount);

    GetMem(PlatformIDs, PlatformCount * SizeOf(cl_platform_id));
    try
      Error := OpenCLDll.clGetPlatformIDs(PlatformCount, PlatformIDs, nil);
      LogCallResult(Error, 'clGetPlatformIDs', '');

      rdgrpPlatforms.Items.Clear;
      for i := 0 to PlatformCount - 1 do
      begin
        rdgrpPlatforms.Items.Add(GetPlatformInfo(PlatformIDs[i], CL_PLATFORM_NAME, 'PlatformName') + ' / ' +
                                 GetPlatformInfo(PlatformIDs[i], CL_PLATFORM_VERSION, 'PlatformVersion'));

        AddToLog('Platform[' + IntToStr(i) + ']:');
        AddToLog('  ' + GetPlatformInfoStr(i, PlatformIDs[i], CL_PLATFORM_PROFILE, 'PlatformProfile'));
        AddToLog('  ' + GetPlatformInfoStr(i, PlatformIDs[i], CL_PLATFORM_VERSION, 'PlatformVersion'));
        AddToLog('  ' + GetPlatformInfoStr(i, PlatformIDs[i], CL_PLATFORM_NAME, 'PlatformName'));
        AddToLog('  ' + GetPlatformInfoStr(i, PlatformIDs[i], CL_PLATFORM_VENDOR, 'PlatformVendor'));
        AddToLog('  ' + GetPlatformInfoStr(i, PlatformIDs[i], CL_PLATFORM_EXTENSIONS, 'PlatformExtensions'));

        Error := OpenCLDll.clGetDeviceIDs(PlatformIDs[i], CL_DEVICE_TYPE_GPU, 0, nil, @DeviceCount);
        LogCallResult(Error, 'clGetDeviceIDs', 'DeviceCount: ' + IntToStr(DeviceCount));
        AddToLog('  ' + 'DeviceCount: ' + IntToStr(DeviceCount));

        SetLength(FAllCLDevices[i], DeviceCount);

        GetMem(DeviceIDs, DeviceCount * SizeOf(cl_device_id));
        try
          Error := OpenCLDll.clGetDeviceIDs(PlatformIDs[i], CL_DEVICE_TYPE_GPU, DeviceCount, DeviceIDs, nil);
          LogCallResult(Error, 'clGetDeviceIDs', '');

          for j := 0 to DeviceCount - 1 do
          begin
            FAllCLDevices[i][j] := GetDeviceInfo(DeviceIDs[j], CL_DEVICE_NAME, 'DeviceName') + ' / ' +
                                   GetDeviceInfo(DeviceIDs[j], CL_DEVICE_OPENCL_C_VERSION, 'DeviceOpenCLCVersion');

            AddToLog('  Device[' + IntToStr(j) + ']:');
            AddToLog('    ' + GetDeviceInfoStr(i, j, DeviceIDs[j], CL_DEVICE_NAME, 'DeviceName'));
            AddToLog('    ' + GetDeviceInfoStr(i, j, DeviceIDs[j], CL_DEVICE_VENDOR, 'DeviceVendor'));
            AddToLog('    ' + GetDeviceInfoStr(i, j, DeviceIDs[j], CL_DEVICE_VERSION, 'DeviceVersion'));
            AddToLog('    ' + GetDeviceInfoStr(i, j, DeviceIDs[j], CL_DEVICE_PROFILE, 'DeviceProfile'));
            AddToLog('    ' + GetDeviceInfoStr(i, j, DeviceIDs[j], CL_DEVICE_OPENCL_C_VERSION, 'DeviceOpenCLCVersion'));
            AddToLog('    ' + GetDeviceInfoStr(i, j, DeviceIDs[j], CL_DEVICE_EXTENSIONS, 'DeviceExtensions'));
            AddToLog('    ' + GetDeviceInfoStr(i, j, DeviceIDs[j], CL_DEVICE_PLATFORM_VERSION, 'DevicePlatformVersion'));

            AddToLog('    ' + GetDeviceInfoStr(i, j, DeviceIDs[j], CL_DEVICE_TYPE_INFO, 'DeviceTypeInfo', True));    //CL_DEVICE_TYPE_GPU
            AddToLog('    ' + GetDeviceInfoStr(i, j, DeviceIDs[j], CL_DEVICE_GLOBAL_MEM_SIZE, 'DeviceGlobalMemSize', True));
            AddToLog('    ' + GetDeviceInfoStr(i, j, DeviceIDs[j], CL_DEVICE_IMAGE_SUPPORT, 'DeviceImageSupport', True));
            AddToLog('    ' + GetDeviceInfoStr(i, j, DeviceIDs[j], CL_DEVICE_LOCAL_MEM_SIZE, 'DeviceLocalMemSize', True));
            AddToLog('    ' + GetDeviceInfoStr(i, j, DeviceIDs[j], CL_DEVICE_AVAILABLE, 'DeviceAvailable', True));
            AddToLog('    ' + GetDeviceInfoStr(i, j, DeviceIDs[j], CL_DEVICE_COMPILER_AVAILABLE, 'DeviceCompilerAvailable', True));
            AddToLog('    ' + GetDeviceInfoStr(i, j, DeviceIDs[j], CL_DEVICE_EXECUTION_CAPABILITIES, 'DeviceExecutionCapabilities', True));
          end;
        finally
          Freemem(DeviceIDs, DeviceCount * SizeOf(cl_device_id));
        end;
      end;
    finally
      Freemem(PlatformIDs, PlatformCount * SizeOf(cl_platform_id));
    end;
  finally
    OpenCLDll.Free;
  end;

  if rdgrpPlatforms.Items.Count > 0 then
  begin
    rdgrpPlatforms.ItemIndex := 0;  //select first platform

    rdgrpDevices.Items.Clear;
    for j := 0 to Length(FAllCLDevices[0]) - 1 do
      rdgrpDevices.Items.Add(FAllCLDevices[0][j]);

    if DeviceCount > 0 then
      rdgrpDevices.ItemIndex := 0;  //select first device
  end;
end;


procedure TfrmNestedCLKernelsMain.tmrStartupTimer(Sender: TObject);
begin
  tmrStartup.Enabled := False;

  AddToLog('Startup...');
  {$IFDEF CPU32}
    AddToLog('32-bit app');
  {$ELSE}
    AddToLog('64-bit app');
  {$ENDIF}

  LoadSettingsFromIni;

  memLog.Lines.BeginUpdate;
  try
    GetOpenCLInfo;
  finally
    memLog.Lines.EndUpdate;
  end;

  LoadKernelFileIntoEditor;

  {$IFDEF UNIX}    //Manual corrections for GTK2
    lbeOpenCLPath.Top := lbeOpenCLPath.Top - 3;
    lbeKernelCode.Top := lbeKernelCode.Top + 3;

    lblModified.Left := spdbtnRunKernelOnDevice.Left;
    lblOptions.Left := spdbtnRunKernelOnDevice.Left;
    chkUseMinusG.Left := spdbtnRunKernelOnDevice.Left;
    chkUseKernelArgInfo.Left := spdbtnRunKernelOnDevice.Left;

    lblSrcBmpWidth.Left := spnedtSrcBmpWidth.Left;
    lblSrcBmpHeight.Left := spnedtSrcBmpHeight.Left;
    lblSubBmpWidth.Left := spnedtSubBmpWidth.Left;
    lblSubBmpHeight.Left := spnedtSubBmpHeight.Left;
    lblSubBmpXPos.Left := spnedtSubBmpXPos.Left;
    lblSubBmpHeight1.Left := spnedtSubBmpYPos.Left;
    lblColorErrorLevel.Left := spnedtColorErrorLevel.Left;
    lblTotalErrorCount.Left := spnedtTotalErrorCount.Left;

    lblSrcBmpWidth.Top := lblSrcBmpWidth.Top - 4;
    lblSrcBmpHeight.Top := lblSrcBmpHeight.Top - 4;
    lblSubBmpWidth.Top := lblSubBmpWidth.Top - 4;
    lblSubBmpHeight.Top := lblSubBmpHeight.Top - 4;
    lblSubBmpXPos.Top := lblSubBmpXPos.Top - 4;
    lblSubBmpHeight1.Top := lblSubBmpHeight1.Top - 4;
    lblColorErrorLevel.Top := lblColorErrorLevel.Top - 4;
    lblTotalErrorCount.Top := lblTotalErrorCount.Top - 4;
  {$ENDIF}
end;

end.

