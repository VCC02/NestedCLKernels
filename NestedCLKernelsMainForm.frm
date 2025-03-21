object frmNestedCLKernelsMain: TfrmNestedCLKernelsMain
  Left = 373
  Height = 430
  Top = 185
  Width = 1009
  Caption = 'Nested CL Kernels'
  ClientHeight = 430
  ClientWidth = 1009
  Constraints.MinHeight = 430
  Constraints.MinWidth = 1009
  LCLVersion = '8.4'
  OnClose = FormClose
  OnCreate = FormCreate
  object memCode: TMemo
    Left = 8
    Height = 223
    Top = 96
    Width = 800
    Anchors = [akTop, akLeft, akRight]
    Font.Height = -13
    Font.Name = 'Courier New'
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
    OnChange = memCodeChange
    OnKeyDown = memCodeKeyDown
  end
  object memLog: TMemo
    Left = 8
    Height = 91
    Top = 329
    Width = 800
    Anchors = [akTop, akLeft, akRight, akBottom]
    Font.Height = -13
    Font.Name = 'Courier New'
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
  end
  object lbeOpenCLPath: TLabeledEdit
    Left = 8
    Height = 23
    Hint = 'Please use the browse button.'
    Top = 20
    Width = 240
    Color = clBtnFace
    EditLabel.Height = 15
    EditLabel.Width = 240
    EditLabel.Caption = 'OpenCL path'
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 2
    Text = 'C:\Windows\System32\OpenCL.dll'
  end
  object btnBrowseOpenCL: TButton
    Left = 256
    Height = 23
    Top = 20
    Width = 24
    Caption = '...'
    TabOrder = 3
    OnClick = btnBrowseOpenCLClick
  end
  object rdgrpPlatforms: TRadioGroup
    Left = 288
    Height = 78
    Top = 8
    Width = 248
    AutoFill = True
    Caption = 'Available platforms'
    ChildSizing.LeftRightSpacing = 6
    ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
    ChildSizing.EnlargeVertical = crsHomogenousChildResize
    ChildSizing.ShrinkHorizontal = crsScaleChilds
    ChildSizing.ShrinkVertical = crsScaleChilds
    ChildSizing.Layout = cclLeftToRightThenTopToBottom
    ChildSizing.ControlsPerLine = 1
    TabOrder = 4
    OnClick = rdgrpPlatformsClick
  end
  object rdgrpDevices: TRadioGroup
    Left = 544
    Height = 78
    Top = 8
    Width = 264
    AutoFill = True
    Caption = 'Available devices'
    ChildSizing.LeftRightSpacing = 6
    ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
    ChildSizing.EnlargeVertical = crsHomogenousChildResize
    ChildSizing.ShrinkHorizontal = crsScaleChilds
    ChildSizing.ShrinkVertical = crsScaleChilds
    ChildSizing.Layout = cclLeftToRightThenTopToBottom
    ChildSizing.ControlsPerLine = 1
    TabOrder = 5
  end
  object btnReloadPlatformInfo: TButton
    Left = 816
    Height = 25
    Top = 8
    Width = 185
    Anchors = [akTop, akRight]
    Caption = 'Reload platform info'
    TabOrder = 6
    OnClick = btnReloadPlatformInfoClick
  end
  object lbeKernelCode: TLabeledEdit
    Left = 8
    Height = 23
    Hint = '$AppDir$ replacement is available.'
    Top = 64
    Width = 240
    EditLabel.Height = 15
    EditLabel.Width = 240
    EditLabel.Caption = 'Kernel code path'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    Text = '$AppDir$\..\NestedKernels.cl'
  end
  object btnBrowseKernelCode: TButton
    Left = 256
    Height = 23
    Top = 64
    Width = 24
    Caption = '...'
    TabOrder = 8
    OnClick = btnBrowseKernelCodeClick
  end
  object btnLoadKernelFile: TButton
    Left = 816
    Height = 25
    Hint = 'Load file from disk into editor.'
    Top = 96
    Width = 185
    Anchors = [akTop, akRight]
    Caption = 'Load kernel file...'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    OnClick = btnLoadKernelFileClick
  end
  object btnSaveKernelFile: TButton
    Left = 816
    Height = 25
    Hint = 'Save to disk.'
    Top = 128
    Width = 185
    Anchors = [akTop, akRight]
    Caption = 'Save kernel file'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
    OnClick = btnSaveKernelFileClick
  end
  object chkUseMinusG: TCheckBox
    Left = 816
    Height = 19
    Top = 184
    Width = 30
    Anchors = [akTop, akRight]
    Caption = '-g'
    TabOrder = 11
  end
  object lblOptions: TLabel
    Left = 816
    Height = 15
    Hint = 'Kernel build options'
    Top = 166
    Width = 42
    Anchors = [akTop, akRight]
    Caption = 'Options'
    ParentShowHint = False
    ShowHint = True
  end
  object chkUseKernelArgInfo: TCheckBox
    Left = 816
    Height = 19
    Top = 208
    Width = 117
    Anchors = [akTop, akRight]
    Caption = '-cl-kernel-arg-info'
    TabOrder = 12
  end
  object spdbtnRunKernelOnDevice: TSpeedButton
    Left = 816
    Height = 25
    Hint = 'Run the currently loaded code on selected device.'
    Top = 40
    Width = 185
    Anchors = [akTop, akRight]
    Caption = 'Run kernel on device'
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4CB1224CB1224CB122FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4CB122
      4CB1224CB1224CB1224CB1224CB122FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFF4CB1224CB1224CB1224CB1224CB1224CB1224C
      B1224CB122FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4CB122
      4CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB122FFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFF4CB1224CB1224CB1224CB1224CB1224CB1224C
      B1224CB1224CB1224CB1224CB1224CB122FFFFFFFFFFFFFFFFFFFFFFFF4CB122
      4CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1
      224CB122FFFFFFFFFFFFFFFFFF4CB1224CB1224CB1224CB1224CB1224CB1224C
      B1224CB1224CB1224CB1224CB1224CB1224CB1224CB122FFFFFFFFFFFF4CB122
      4CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1
      224CB1224CB122FFFFFFFFFFFF4CB1224CB1224CB1224CB1224CB1224CB1224C
      B1224CB1224CB1224CB1224CB1224CB1224CB122FFFFFFFFFFFFFFFFFF4CB122
      4CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1
      22FFFFFFFFFFFFFFFFFFFFFFFF4CB1224CB1224CB1224CB1224CB1224CB1224C
      B1224CB1224CB1224CB122FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4CB122
      4CB1224CB1224CB1224CB1224CB1224CB1224CB122FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFF4CB1224CB1224CB1224CB1224CB1224CB122FF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      4CB1224CB1224CB122FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    }
    ShowHint = True
    ParentShowHint = False
    OnClick = spdbtnRunKernelOnDeviceClick
  end
  object lblModified: TLabel
    Left = 816
    Height = 15
    Top = 71
    Width = 50
    Anchors = [akTop, akRight]
    Caption = 'Modified'
    Font.Color = clMaroon
    Font.Style = [fsBold]
    ParentFont = False
  end
  object spnedtSrcBmpWidth: TSpinEdit
    Left = 816
    Height = 23
    Top = 248
    Width = 88
    Anchors = [akTop, akRight]
    MaxValue = 4095
    MinValue = 3
    TabOrder = 13
    Value = 300
  end
  object lblSrcBmpWidth: TLabel
    Left = 816
    Height = 15
    Hint = 'Background bitmap'
    Top = 232
    Width = 73
    Anchors = [akTop, akRight]
    Caption = 'SrcBmpWidth'
    ParentShowHint = False
    ShowHint = True
  end
  object spnedtSrcBmpHeight: TSpinEdit
    Left = 912
    Height = 23
    Top = 248
    Width = 89
    Anchors = [akTop, akRight]
    MaxValue = 4095
    MinValue = 3
    TabOrder = 14
    Value = 400
  end
  object lblSrcBmpHeight: TLabel
    Left = 912
    Height = 15
    Hint = 'Background bitmap'
    Top = 232
    Width = 77
    Anchors = [akTop, akRight]
    Caption = 'SrcBmpHeight'
    ParentShowHint = False
    ShowHint = True
  end
  object spnedtSubBmpWidth: TSpinEdit
    Left = 816
    Height = 23
    Top = 296
    Width = 88
    Anchors = [akTop, akRight]
    MaxValue = 4095
    MinValue = 3
    TabOrder = 15
    Value = 30
  end
  object lblSubBmpWidth: TLabel
    Left = 816
    Height = 15
    Hint = 'Sub bitmap'
    Top = 280
    Width = 77
    Anchors = [akTop, akRight]
    Caption = 'SubBmpWidth'
    ParentShowHint = False
    ShowHint = True
  end
  object spnedtSubBmpHeight: TSpinEdit
    Left = 912
    Height = 23
    Top = 296
    Width = 89
    Anchors = [akTop, akRight]
    MaxValue = 4095
    MinValue = 3
    TabOrder = 16
    Value = 40
  end
  object lblSubBmpHeight: TLabel
    Left = 912
    Height = 15
    Hint = 'Sub bitmap'
    Top = 280
    Width = 81
    Anchors = [akTop, akRight]
    Caption = 'SubBmpHeight'
    ParentShowHint = False
    ShowHint = True
  end
  object spnedtSubBmpXPos: TSpinEdit
    Left = 816
    Height = 23
    Top = 344
    Width = 88
    Anchors = [akTop, akRight]
    MaxValue = 4095
    TabOrder = 17
    Value = 21
  end
  object lblSubBmpXPos: TLabel
    Left = 816
    Height = 15
    Hint = 'Sub bitmap'
    Top = 328
    Width = 71
    Anchors = [akTop, akRight]
    Caption = 'SubBmpXPos'
    ParentShowHint = False
    ShowHint = True
  end
  object spnedtSubBmpYPos: TSpinEdit
    Left = 912
    Height = 23
    Top = 344
    Width = 89
    Anchors = [akTop, akRight]
    MaxValue = 4095
    TabOrder = 18
    Value = 17
  end
  object lblSubBmpHeight1: TLabel
    Left = 912
    Height = 15
    Hint = 'Sub bitmap'
    Top = 328
    Width = 71
    Anchors = [akTop, akRight]
    Caption = 'SubBmpYPos'
    ParentShowHint = False
    ShowHint = True
  end
  object spnedtColorErrorLevel: TSpinEdit
    Left = 816
    Height = 23
    Top = 392
    Width = 88
    Anchors = [akTop, akRight]
    MaxValue = 255
    TabOrder = 19
    Value = 20
  end
  object lblColorErrorLevel: TLabel
    Left = 816
    Height = 15
    Hint = 'The difference between SrcBmp pixel color and SubBmp pixel color, for every R, G, B channel, which doesn''t count as different pixels.'
    Top = 376
    Width = 81
    Anchors = [akTop, akRight]
    Caption = 'ColorErrorLevel'
    ParentShowHint = False
    ShowHint = True
  end
  object spnedtTotalErrorCount: TSpinEdit
    Left = 912
    Height = 23
    Top = 392
    Width = 88
    Anchors = [akTop, akRight]
    MaxValue = 7000
    TabOrder = 20
    Value = 20
  end
  object lblTotalErrorCount: TLabel
    Left = 912
    Height = 15
    Hint = 'Maximum number of different pixels, for a valid match.'
    Top = 376
    Width = 85
    Anchors = [akTop, akRight]
    Caption = 'TotalErrorCount'
    ParentShowHint = False
    ShowHint = True
  end
  object tmrStartup: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrStartupTimer
    Left = 552
    Top = 82
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Dynamic link libraries (*.dll; *.so)|*.dll; *.so|All files (*.*)|*.*'
    Left = 552
    Top = 144
  end
  object tmrPlatformSelection: TTimer
    Enabled = False
    Interval = 10
    OnTimer = tmrPlatformSelectionTimer
    Left = 664
    Top = 82
  end
  object OpenDialog2: TOpenDialog
    Filter = 'OpenCL kernel files (*.cl)|*.cl|All files (*.*)|*.*'
    Left = 664
    Top = 144
  end
end
