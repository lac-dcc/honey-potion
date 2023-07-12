; ModuleID = 'prog.bpf.c'
source_filename = "prog.bpf.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.anon.1 = type { ptr, ptr, ptr, ptr }
%struct.anon.2 = type { ptr, ptr, ptr, ptr }
%struct.anon.3 = type { ptr, ptr, ptr, ptr }
%struct.anon.4 = type { ptr, ptr, ptr, ptr }
%struct.anon.5 = type { ptr, ptr, ptr, ptr }
%struct.state = type { i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32, i32 }
%struct.goto_result = type { i32, i32 }
%struct.data = type { [10 x i8], i32 }

@config = dso_local global %struct.anon.1 zeroinitializer, section ".maps", align 8, !dbg !0
@state_map = dso_local global %struct.anon.2 zeroinitializer, section ".maps", align 8, !dbg !268
@matchPayload.____fmt = internal constant [48 x i8] c"Continue to analyze packet from index %d to %d.\00", align 1, !dbg !85
@matchPayload.____fmt.1 = internal constant [51 x i8] c"Packet received. payload_size = %u. Let's process.\00", align 1, !dbg !200
@goto_func = dso_local global %struct.anon.3 zeroinitializer, section ".maps", align 8, !dbg !238
@strings = dso_local global %struct.anon.4 zeroinitializer, section ".maps", align 8, !dbg !222
@__const.matchPayload.fmt = private unnamed_addr constant [60 x i8] c"Found the word '%s'. It's the %dth packet with this string.\00", align 1
@.str = private unnamed_addr constant [13 x i8] c"Dropping...\0A\00", align 1, !dbg !205
@.str.2 = private unnamed_addr constant [12 x i8] c"Passing...\0A\00", align 1, !dbg !210
@matchPayload.____fmt.3 = internal constant [37 x i8] c"Packet fully analyzed (%d bytes). %s\00", align 1, !dbg !215
@progs = dso_local global %struct.anon.5 zeroinitializer, section ".maps", align 8, !dbg !252
@_license = dso_local global [13 x i8] c"Dual BSD/GPL\00", section "license", align 1, !dbg !220
@llvm.compiler.used = appending global [7 x ptr] [ptr @_license, ptr @config, ptr @goto_func, ptr @matchPayload, ptr @progs, ptr @state_map, ptr @strings], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @matchPayload(ptr noundef %0) #0 section "matchPayloadUDP" !dbg !87 {
  %2 = alloca i8, align 1
  %3 = alloca %struct.state, align 4
  %4 = getelementptr inbounds %struct.state, ptr %3, i64 0, i32 2
  %5 = getelementptr inbounds %struct.state, ptr %3, i64 0, i32 1
  %6 = alloca i64, align 8
  %7 = alloca i32, align 4
  %8 = alloca [60 x i8], align 1
  %9 = alloca [14 x i8], align 1
  %10 = alloca i64, align 8
  call void @llvm.dbg.value(metadata ptr %0, metadata !100, metadata !DIExpression()), !dbg !324
  %11 = getelementptr inbounds %struct.xdp_md, ptr %0, i64 0, i32 1, !dbg !325
  %12 = load i32, ptr %11, align 4, !dbg !325, !tbaa !326
  %13 = zext i32 %12 to i64, !dbg !331
  %14 = inttoptr i64 %13 to ptr, !dbg !332
  call void @llvm.dbg.value(metadata ptr %14, metadata !101, metadata !DIExpression()), !dbg !324
  %15 = load i32, ptr %0, align 4, !dbg !333, !tbaa !334
  %16 = zext i32 %15 to i64, !dbg !335
  %17 = inttoptr i64 %16 to ptr, !dbg !336
  call void @llvm.dbg.value(metadata ptr %17, metadata !102, metadata !DIExpression()), !dbg !324
  call void @llvm.dbg.value(metadata ptr %17, metadata !103, metadata !DIExpression()), !dbg !324
  %18 = getelementptr i8, ptr %17, i64 14, !dbg !337
  %19 = icmp ugt ptr %18, %14, !dbg !339
  %20 = getelementptr i8, ptr %17, i64 34
  %21 = icmp ugt ptr %20, %14
  %22 = or i1 %19, %21, !dbg !340
  call void @llvm.dbg.value(metadata ptr %18, metadata !128, metadata !DIExpression()), !dbg !324
  br i1 %22, label %195, label %23, !dbg !340

23:                                               ; preds = %1
  %24 = getelementptr i8, ptr %17, i64 23, !dbg !341
  %25 = load i8, ptr %24, align 1, !dbg !341, !tbaa !343
  %26 = icmp eq i8 %25, 17, !dbg !346
  br i1 %26, label %27, label %195, !dbg !347

27:                                               ; preds = %23
  call void @llvm.dbg.value(metadata ptr undef, metadata !118, metadata !DIExpression()), !dbg !324
  %28 = getelementptr i8, ptr %17, i64 42, !dbg !348
  %29 = icmp ugt ptr %28, %14, !dbg !350
  br i1 %29, label %195, label %30, !dbg !351

30:                                               ; preds = %27
  call void @llvm.dbg.value(metadata ptr %28, metadata !157, metadata !DIExpression()), !dbg !324
  %31 = getelementptr i8, ptr %17, i64 38, !dbg !352
  %32 = load i16, ptr %31, align 2, !dbg !352, !tbaa !353
  %33 = tail call i16 @llvm.bswap.i16(i16 %32)
  %34 = zext i16 %33 to i32, !dbg !352
  %35 = add nsw i32 %34, -8, !dbg !355
  call void @llvm.dbg.value(metadata i32 %35, metadata !159, metadata !DIExpression()), !dbg !324
  %36 = zext i32 %35 to i64, !dbg !356
  %37 = getelementptr i8, ptr %28, i64 %36, !dbg !356
  %38 = icmp ugt ptr %37, %14, !dbg !358
  br i1 %38, label %195, label %39, !dbg !359

39:                                               ; preds = %30
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %2) #5, !dbg !360
  call void @llvm.dbg.value(metadata i8 112, metadata !160, metadata !DIExpression()), !dbg !324
  store i8 112, ptr %2, align 1, !dbg !361, !tbaa !362
  call void @llvm.dbg.value(metadata ptr %2, metadata !160, metadata !DIExpression(DW_OP_deref)), !dbg !324
  %40 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @config, ptr noundef nonnull %2) #5, !dbg !363
  call void @llvm.dbg.value(metadata ptr %40, metadata !161, metadata !DIExpression()), !dbg !324
  %41 = icmp eq ptr %40, null, !dbg !364
  br i1 %41, label %193, label %42, !dbg !366

42:                                               ; preds = %39
  %43 = getelementptr i8, ptr %17, i64 36, !dbg !367
  %44 = load i16, ptr %43, align 2, !dbg !367, !tbaa !368
  %45 = load i32, ptr %40, align 4, !dbg !369, !tbaa !370
  %46 = trunc i32 %45 to i16, !dbg !369
  %47 = call i16 @llvm.bswap.i16(i16 %46)
  %48 = icmp eq i16 %44, %47, !dbg !371
  br i1 %48, label %49, label %193, !dbg !372

49:                                               ; preds = %42
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %3) #5, !dbg !373
  call void @llvm.dbg.declare(metadata ptr %3, metadata !162, metadata !DIExpression()), !dbg !374
  call void @llvm.dbg.value(metadata ptr %3, metadata !163, metadata !DIExpression()), !dbg !324
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %6) #5, !dbg !375
  %50 = ptrtoint ptr %0 to i64, !dbg !376
  call void @llvm.dbg.value(metadata i64 %50, metadata !164, metadata !DIExpression()), !dbg !324
  store i64 %50, ptr %6, align 8, !dbg !377, !tbaa !378
  call void @llvm.dbg.value(metadata ptr %6, metadata !164, metadata !DIExpression(DW_OP_deref)), !dbg !324
  %51 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @state_map, ptr noundef nonnull %6) #5, !dbg !380
  call void @llvm.dbg.value(metadata ptr %51, metadata !165, metadata !DIExpression()), !dbg !324
  %52 = icmp eq ptr %51, null, !dbg !381
  br i1 %52, label %59, label %53, !dbg !383

53:                                               ; preds = %49
  %54 = getelementptr inbounds %struct.state, ptr %51, i64 0, i32 1, !dbg !324
  %55 = getelementptr inbounds %struct.state, ptr %51, i64 0, i32 2, !dbg !324
  call void @llvm.dbg.value(metadata ptr %51, metadata !163, metadata !DIExpression()), !dbg !324
  %56 = load i32, ptr %51, align 4, !dbg !384, !tbaa !387
  %57 = add i32 %56, 1999, !dbg !384
  %58 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @matchPayload.____fmt, i32 noundef 48, i32 noundef %56, i32 noundef %57) #5, !dbg !384
  br label %62, !dbg !389

59:                                               ; preds = %49
  %60 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @matchPayload.____fmt.1, i32 noundef 51, i32 noundef %35) #5, !dbg !390
  store i32 1, ptr %5, align 4, !dbg !393, !tbaa !394
  store i32 0, ptr %3, align 4, !dbg !395, !tbaa !387
  store i32 0, ptr %4, align 4, !dbg !396, !tbaa !397
  call void @llvm.dbg.value(metadata ptr %6, metadata !164, metadata !DIExpression(DW_OP_deref)), !dbg !324
  %61 = call i64 inttoptr (i64 2 to ptr)(ptr noundef nonnull @state_map, ptr noundef nonnull %6, ptr noundef nonnull %3, i64 noundef 0) #5, !dbg !398
  br label %62

62:                                               ; preds = %59, %53
  %63 = phi ptr [ %51, %53 ], [ %3, %59 ], !dbg !324
  %64 = phi ptr [ %54, %53 ], [ %5, %59 ], !dbg !324
  %65 = phi ptr [ %55, %53 ], [ %4, %59 ], !dbg !324
  call void @llvm.dbg.value(metadata ptr %63, metadata !163, metadata !DIExpression()), !dbg !324
  call void @llvm.dbg.value(metadata i32 0, metadata !166, metadata !DIExpression()), !dbg !324
  call void @llvm.dbg.value(metadata i32 0, metadata !167, metadata !DIExpression()), !dbg !324
  br label %66, !dbg !399

66:                                               ; preds = %62, %95
  %67 = phi i32 [ 0, %62 ], [ %96, %95 ]
  call void @llvm.dbg.value(metadata i32 %67, metadata !167, metadata !DIExpression()), !dbg !324
  %68 = load i32, ptr %63, align 4, !dbg !400, !tbaa !387
  %69 = add i32 %68, %67, !dbg !401
  call void @llvm.dbg.value(metadata i32 %69, metadata !168, metadata !DIExpression()), !dbg !402
  %70 = icmp ugt i32 %69, 65492, !dbg !403
  br i1 %70, label %98, label %71, !dbg !405

71:                                               ; preds = %66
  %72 = zext i32 %69 to i64, !dbg !406
  %73 = getelementptr i8, ptr %28, i64 %72, !dbg !406
  %74 = getelementptr i8, ptr %73, i64 1, !dbg !407
  %75 = icmp ugt ptr %74, %14, !dbg !408
  br i1 %75, label %98, label %76, !dbg !409

76:                                               ; preds = %71
  %77 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @goto_func, ptr noundef nonnull %64) #5, !dbg !410
  call void @llvm.dbg.value(metadata ptr %77, metadata !172, metadata !DIExpression()), !dbg !402
  %78 = icmp eq ptr %77, null, !dbg !411
  br i1 %78, label %186, label %79, !dbg !413

79:                                               ; preds = %76
  %80 = load i8, ptr %73, align 1, !dbg !414, !tbaa !362
  %81 = zext i8 %80 to i32, !dbg !414
  %82 = add nsw i32 %81, -97, !dbg !415
  call void @llvm.dbg.value(metadata i32 %82, metadata !173, metadata !DIExpression()), !dbg !402
  %83 = icmp ugt i32 %82, 25, !dbg !416
  br i1 %83, label %84, label %85, !dbg !418

84:                                               ; preds = %79
  store i32 1, ptr %64, align 4, !dbg !419, !tbaa !394
  br label %95, !dbg !421

85:                                               ; preds = %79
  %86 = zext i32 %82 to i64, !dbg !422
  %87 = getelementptr inbounds %struct.goto_result, ptr %77, i64 %86, !dbg !422
  %88 = load i32, ptr %87, align 4, !dbg !423, !tbaa !424
  store i32 %88, ptr %64, align 4, !dbg !426, !tbaa !394
  %89 = getelementptr inbounds %struct.goto_result, ptr %77, i64 %86, i32 1, !dbg !427
  %90 = load i32, ptr %89, align 4, !dbg !427, !tbaa !429
  %91 = icmp eq i32 %90, 0, !dbg !430
  br i1 %91, label %95, label %92, !dbg !431

92:                                               ; preds = %85
  %93 = load i32, ptr %65, align 4, !dbg !432, !tbaa !397
  %94 = or i32 %93, %90, !dbg !432
  store i32 %94, ptr %65, align 4, !dbg !432, !tbaa !397
  br label %95, !dbg !433

95:                                               ; preds = %84, %92, %85
  call void @llvm.dbg.value(metadata i32 0, metadata !166, metadata !DIExpression()), !dbg !324
  %96 = add nuw nsw i32 %67, 1, !dbg !434
  call void @llvm.dbg.value(metadata i32 %96, metadata !167, metadata !DIExpression()), !dbg !324
  %97 = icmp eq i32 %96, 2000, !dbg !435
  br i1 %97, label %186, label %66, !dbg !399, !llvm.loop !436

98:                                               ; preds = %66, %71
  call void @llvm.dbg.value(metadata i32 undef, metadata !166, metadata !DIExpression()), !dbg !324
  %99 = getelementptr inbounds %struct.state, ptr %63, i64 0, i32 2
  call void @llvm.dbg.value(metadata i32 0, metadata !174, metadata !DIExpression()), !dbg !439
  call void @llvm.dbg.value(metadata i32 0, metadata !174, metadata !DIExpression()), !dbg !439
  %100 = load i32, ptr %99, align 4, !dbg !440, !tbaa !397
  %101 = and i32 %100, 1, !dbg !441
  %102 = icmp eq i32 %101, 0, !dbg !441
  br i1 %102, label %114, label %103, !dbg !442

103:                                              ; preds = %98
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %7) #5, !dbg !443
  call void @llvm.dbg.value(metadata i32 0, metadata !178, metadata !DIExpression()), !dbg !444
  store i32 0, ptr %7, align 4, !dbg !445, !tbaa !370
  call void @llvm.dbg.value(metadata ptr %7, metadata !178, metadata !DIExpression(DW_OP_deref)), !dbg !444
  %104 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @strings, ptr noundef nonnull %7) #5, !dbg !446
  call void @llvm.dbg.value(metadata ptr %104, metadata !183, metadata !DIExpression()), !dbg !444
  %105 = icmp eq ptr %104, null, !dbg !447
  br i1 %105, label %112, label %106, !dbg !448

106:                                              ; preds = %103
  %107 = getelementptr inbounds %struct.data, ptr %104, i64 0, i32 1, !dbg !449
  %108 = load i32, ptr %107, align 4, !dbg !450, !tbaa !451
  %109 = add nsw i32 %108, 1, !dbg !450
  store i32 %109, ptr %107, align 4, !dbg !450, !tbaa !451
  call void @llvm.lifetime.start.p0(i64 60, ptr nonnull %8) #5, !dbg !453
  call void @llvm.dbg.declare(metadata ptr %8, metadata !184, metadata !DIExpression()), !dbg !454
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(60) %8, ptr noundef nonnull align 1 dereferenceable(60) @__const.matchPayload.fmt, i64 60, i1 false), !dbg !454
  %110 = load i32, ptr %107, align 4, !dbg !455, !tbaa !451
  %111 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull %8, i32 noundef 60, ptr noundef nonnull %104, i32 noundef %110) #5, !dbg !456
  call void @llvm.lifetime.end.p0(i64 60, ptr nonnull %8) #5, !dbg !457
  br label %112, !dbg !458

112:                                              ; preds = %106, %103
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %7) #5, !dbg !459
  %113 = load i32, ptr %99, align 4, !dbg !440, !tbaa !397
  br label %114, !dbg !460

114:                                              ; preds = %98, %112
  %115 = phi i32 [ %100, %98 ], [ %113, %112 ], !dbg !440
  call void @llvm.dbg.value(metadata i32 1, metadata !174, metadata !DIExpression()), !dbg !439
  call void @llvm.dbg.value(metadata i32 1, metadata !174, metadata !DIExpression()), !dbg !439
  %116 = and i32 %115, 2, !dbg !441
  %117 = icmp eq i32 %116, 0, !dbg !441
  br i1 %117, label %129, label %118, !dbg !442

118:                                              ; preds = %114
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %7) #5, !dbg !443
  call void @llvm.dbg.value(metadata i32 1, metadata !178, metadata !DIExpression()), !dbg !444
  store i32 1, ptr %7, align 4, !dbg !445, !tbaa !370
  call void @llvm.dbg.value(metadata ptr %7, metadata !178, metadata !DIExpression(DW_OP_deref)), !dbg !444
  %119 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @strings, ptr noundef nonnull %7) #5, !dbg !446
  call void @llvm.dbg.value(metadata ptr %119, metadata !183, metadata !DIExpression()), !dbg !444
  %120 = icmp eq ptr %119, null, !dbg !447
  br i1 %120, label %127, label %121, !dbg !448

121:                                              ; preds = %118
  %122 = getelementptr inbounds %struct.data, ptr %119, i64 0, i32 1, !dbg !449
  %123 = load i32, ptr %122, align 4, !dbg !450, !tbaa !451
  %124 = add nsw i32 %123, 1, !dbg !450
  store i32 %124, ptr %122, align 4, !dbg !450, !tbaa !451
  call void @llvm.lifetime.start.p0(i64 60, ptr nonnull %8) #5, !dbg !453
  call void @llvm.dbg.declare(metadata ptr %8, metadata !184, metadata !DIExpression()), !dbg !454
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(60) %8, ptr noundef nonnull align 1 dereferenceable(60) @__const.matchPayload.fmt, i64 60, i1 false), !dbg !454
  %125 = load i32, ptr %122, align 4, !dbg !455, !tbaa !451
  %126 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull %8, i32 noundef 60, ptr noundef nonnull %119, i32 noundef %125) #5, !dbg !456
  call void @llvm.lifetime.end.p0(i64 60, ptr nonnull %8) #5, !dbg !457
  br label %127, !dbg !458

127:                                              ; preds = %121, %118
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %7) #5, !dbg !459
  %128 = load i32, ptr %99, align 4, !dbg !440, !tbaa !397
  br label %129, !dbg !460

129:                                              ; preds = %127, %114
  %130 = phi i32 [ %128, %127 ], [ %115, %114 ], !dbg !440
  call void @llvm.dbg.value(metadata i32 2, metadata !174, metadata !DIExpression()), !dbg !439
  call void @llvm.dbg.value(metadata i32 2, metadata !174, metadata !DIExpression()), !dbg !439
  %131 = and i32 %130, 4, !dbg !441
  %132 = icmp eq i32 %131, 0, !dbg !441
  br i1 %132, label %144, label %133, !dbg !442

133:                                              ; preds = %129
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %7) #5, !dbg !443
  call void @llvm.dbg.value(metadata i32 2, metadata !178, metadata !DIExpression()), !dbg !444
  store i32 2, ptr %7, align 4, !dbg !445, !tbaa !370
  call void @llvm.dbg.value(metadata ptr %7, metadata !178, metadata !DIExpression(DW_OP_deref)), !dbg !444
  %134 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @strings, ptr noundef nonnull %7) #5, !dbg !446
  call void @llvm.dbg.value(metadata ptr %134, metadata !183, metadata !DIExpression()), !dbg !444
  %135 = icmp eq ptr %134, null, !dbg !447
  br i1 %135, label %142, label %136, !dbg !448

136:                                              ; preds = %133
  %137 = getelementptr inbounds %struct.data, ptr %134, i64 0, i32 1, !dbg !449
  %138 = load i32, ptr %137, align 4, !dbg !450, !tbaa !451
  %139 = add nsw i32 %138, 1, !dbg !450
  store i32 %139, ptr %137, align 4, !dbg !450, !tbaa !451
  call void @llvm.lifetime.start.p0(i64 60, ptr nonnull %8) #5, !dbg !453
  call void @llvm.dbg.declare(metadata ptr %8, metadata !184, metadata !DIExpression()), !dbg !454
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(60) %8, ptr noundef nonnull align 1 dereferenceable(60) @__const.matchPayload.fmt, i64 60, i1 false), !dbg !454
  %140 = load i32, ptr %137, align 4, !dbg !455, !tbaa !451
  %141 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull %8, i32 noundef 60, ptr noundef nonnull %134, i32 noundef %140) #5, !dbg !456
  call void @llvm.lifetime.end.p0(i64 60, ptr nonnull %8) #5, !dbg !457
  br label %142, !dbg !458

142:                                              ; preds = %136, %133
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %7) #5, !dbg !459
  %143 = load i32, ptr %99, align 4, !dbg !440, !tbaa !397
  br label %144, !dbg !460

144:                                              ; preds = %142, %129
  %145 = phi i32 [ %143, %142 ], [ %130, %129 ], !dbg !440
  call void @llvm.dbg.value(metadata i32 3, metadata !174, metadata !DIExpression()), !dbg !439
  call void @llvm.dbg.value(metadata i32 3, metadata !174, metadata !DIExpression()), !dbg !439
  %146 = and i32 %145, 8, !dbg !441
  %147 = icmp eq i32 %146, 0, !dbg !441
  br i1 %147, label %159, label %148, !dbg !442

148:                                              ; preds = %144
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %7) #5, !dbg !443
  call void @llvm.dbg.value(metadata i32 3, metadata !178, metadata !DIExpression()), !dbg !444
  store i32 3, ptr %7, align 4, !dbg !445, !tbaa !370
  call void @llvm.dbg.value(metadata ptr %7, metadata !178, metadata !DIExpression(DW_OP_deref)), !dbg !444
  %149 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @strings, ptr noundef nonnull %7) #5, !dbg !446
  call void @llvm.dbg.value(metadata ptr %149, metadata !183, metadata !DIExpression()), !dbg !444
  %150 = icmp eq ptr %149, null, !dbg !447
  br i1 %150, label %157, label %151, !dbg !448

151:                                              ; preds = %148
  %152 = getelementptr inbounds %struct.data, ptr %149, i64 0, i32 1, !dbg !449
  %153 = load i32, ptr %152, align 4, !dbg !450, !tbaa !451
  %154 = add nsw i32 %153, 1, !dbg !450
  store i32 %154, ptr %152, align 4, !dbg !450, !tbaa !451
  call void @llvm.lifetime.start.p0(i64 60, ptr nonnull %8) #5, !dbg !453
  call void @llvm.dbg.declare(metadata ptr %8, metadata !184, metadata !DIExpression()), !dbg !454
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(60) %8, ptr noundef nonnull align 1 dereferenceable(60) @__const.matchPayload.fmt, i64 60, i1 false), !dbg !454
  %155 = load i32, ptr %152, align 4, !dbg !455, !tbaa !451
  %156 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull %8, i32 noundef 60, ptr noundef nonnull %149, i32 noundef %155) #5, !dbg !456
  call void @llvm.lifetime.end.p0(i64 60, ptr nonnull %8) #5, !dbg !457
  br label %157, !dbg !458

157:                                              ; preds = %151, %148
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %7) #5, !dbg !459
  %158 = load i32, ptr %99, align 4, !dbg !440, !tbaa !397
  br label %159, !dbg !460

159:                                              ; preds = %157, %144
  %160 = phi i32 [ %158, %157 ], [ %145, %144 ], !dbg !440
  call void @llvm.dbg.value(metadata i32 4, metadata !174, metadata !DIExpression()), !dbg !439
  call void @llvm.dbg.value(metadata i32 4, metadata !174, metadata !DIExpression()), !dbg !439
  %161 = and i32 %160, 16, !dbg !441
  %162 = icmp eq i32 %161, 0, !dbg !441
  br i1 %162, label %174, label %163, !dbg !442

163:                                              ; preds = %159
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %7) #5, !dbg !443
  call void @llvm.dbg.value(metadata i32 4, metadata !178, metadata !DIExpression()), !dbg !444
  store i32 4, ptr %7, align 4, !dbg !445, !tbaa !370
  call void @llvm.dbg.value(metadata ptr %7, metadata !178, metadata !DIExpression(DW_OP_deref)), !dbg !444
  %164 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @strings, ptr noundef nonnull %7) #5, !dbg !446
  call void @llvm.dbg.value(metadata ptr %164, metadata !183, metadata !DIExpression()), !dbg !444
  %165 = icmp eq ptr %164, null, !dbg !447
  br i1 %165, label %172, label %166, !dbg !448

166:                                              ; preds = %163
  %167 = getelementptr inbounds %struct.data, ptr %164, i64 0, i32 1, !dbg !449
  %168 = load i32, ptr %167, align 4, !dbg !450, !tbaa !451
  %169 = add nsw i32 %168, 1, !dbg !450
  store i32 %169, ptr %167, align 4, !dbg !450, !tbaa !451
  call void @llvm.lifetime.start.p0(i64 60, ptr nonnull %8) #5, !dbg !453
  call void @llvm.dbg.declare(metadata ptr %8, metadata !184, metadata !DIExpression()), !dbg !454
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(60) %8, ptr noundef nonnull align 1 dereferenceable(60) @__const.matchPayload.fmt, i64 60, i1 false), !dbg !454
  %170 = load i32, ptr %167, align 4, !dbg !455, !tbaa !451
  %171 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull %8, i32 noundef 60, ptr noundef nonnull %164, i32 noundef %170) #5, !dbg !456
  call void @llvm.lifetime.end.p0(i64 60, ptr nonnull %8) #5, !dbg !457
  br label %172, !dbg !458

172:                                              ; preds = %166, %163
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %7) #5, !dbg !459
  %173 = load i32, ptr %99, align 4, !dbg !461, !tbaa !397
  br label %174, !dbg !460

174:                                              ; preds = %172, %159
  %175 = phi i32 [ %173, %172 ], [ %160, %159 ], !dbg !461
  call void @llvm.dbg.value(metadata i32 5, metadata !174, metadata !DIExpression()), !dbg !439
  call void @llvm.lifetime.start.p0(i64 14, ptr nonnull %9) #5, !dbg !463
  call void @llvm.dbg.declare(metadata ptr %9, metadata !190, metadata !DIExpression()), !dbg !464
  %176 = icmp eq i32 %175, 0, !dbg !465
  br i1 %176, label %178, label %177, !dbg !466

177:                                              ; preds = %174
  call void @llvm.dbg.value(metadata i32 1, metadata !194, metadata !DIExpression()), !dbg !467
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(14) %9, ptr noundef nonnull align 1 dereferenceable(14) @.str, i64 14, i1 false), !dbg !468
  br label %179, !dbg !470

178:                                              ; preds = %174
  call void @llvm.dbg.value(metadata i32 2, metadata !194, metadata !DIExpression()), !dbg !467
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(12) %9, ptr noundef nonnull align 1 dereferenceable(12) @.str.2, i64 12, i1 false), !dbg !471
  br label %179

179:                                              ; preds = %178, %177
  %180 = phi i32 [ 1, %177 ], [ 2, %178 ], !dbg !473
  call void @llvm.dbg.value(metadata i32 %180, metadata !194, metadata !DIExpression()), !dbg !467
  %181 = load i32, ptr %63, align 4, !dbg !474, !tbaa !387
  %182 = add nsw i32 %67, -1, !dbg !474
  %183 = add i32 %182, %181, !dbg !474
  %184 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @matchPayload.____fmt.3, i32 noundef 37, i32 noundef %183, ptr noundef nonnull %9) #5, !dbg !474
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %10) #5, !dbg !476
  call void @llvm.dbg.value(metadata i64 %50, metadata !195, metadata !DIExpression()), !dbg !467
  store i64 %50, ptr %10, align 8, !dbg !477, !tbaa !378
  call void @llvm.dbg.value(metadata ptr %10, metadata !195, metadata !DIExpression(DW_OP_deref)), !dbg !467
  %185 = call i64 inttoptr (i64 3 to ptr)(ptr noundef nonnull @state_map, ptr noundef nonnull %10) #5, !dbg !478
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %10) #5, !dbg !479
  call void @llvm.lifetime.end.p0(i64 14, ptr nonnull %9) #5, !dbg !479
  br label %191

186:                                              ; preds = %76, %95
  %187 = phi i32 [ %67, %76 ], [ 2000, %95 ], !dbg !480
  call void @llvm.dbg.value(metadata i32 undef, metadata !166, metadata !DIExpression()), !dbg !324
  %188 = load i32, ptr %63, align 4, !dbg !481, !tbaa !387
  %189 = add i32 %188, %187, !dbg !481
  store i32 %189, ptr %63, align 4, !dbg !481, !tbaa !387
  %190 = call i64 inttoptr (i64 12 to ptr)(ptr noundef nonnull %0, ptr noundef nonnull @progs, i32 noundef 0) #5, !dbg !483
  br label %191, !dbg !484

191:                                              ; preds = %186, %179
  %192 = phi i32 [ %180, %179 ], [ 2, %186 ], !dbg !485
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %6) #5, !dbg !486
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %3) #5, !dbg !486
  br label %193

193:                                              ; preds = %39, %42, %191
  %194 = phi i32 [ %192, %191 ], [ 2, %42 ], [ 2, %39 ], !dbg !324
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %2) #5, !dbg !486
  br label %195

195:                                              ; preds = %193, %30, %27, %23, %1
  %196 = phi i32 [ 2, %1 ], [ 2, %23 ], [ 2, %27 ], [ %194, %193 ], [ 2, %30 ], !dbg !324
  ret i32 %196, !dbg !486
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #2

; Function Attrs: argmemonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #2

; Function Attrs: argmemonly mustprogress nocallback nofree nounwind willreturn
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #3

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #4

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i16 @llvm.bswap.i16(i16) #4

attributes #0 = { nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly mustprogress nocallback nofree nosync nounwind willreturn }
attributes #3 = { argmemonly mustprogress nocallback nofree nounwind willreturn }
attributes #4 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!319, !320, !321, !322}
!llvm.ident = !{!323}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "config", scope: !2, file: !3, line: 16, type: !312, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 15.0.7", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !52, globals: !84, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "prog.bpf.c", directory: "/run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/benchmarks/programs/findstring", checksumkind: CSK_MD5, checksum: "7f014747bd29115cc77399eb63a847cc")
!4 = !{!5, !14, !46}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 6130, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/include/linux/bpf.h", directory: "", checksumkind: CSK_MD5, checksum: "b90a69f1fa9b9ccf0c666897a6f64ece")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2)
!12 = !DIEnumerator(name: "XDP_TX", value: 3)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!14 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !15, line: 40, baseType: !7, size: 32, elements: !16)
!15 = !DIFile(filename: "/usr/include/netinet/in.h", directory: "", checksumkind: CSK_MD5, checksum: "b19632dbf3144fab79301e846e1f6726")
!16 = !{!17, !18, !19, !20, !21, !22, !23, !24, !25, !26, !27, !28, !29, !30, !31, !32, !33, !34, !35, !36, !37, !38, !39, !40, !41, !42, !43, !44, !45}
!17 = !DIEnumerator(name: "IPPROTO_IP", value: 0)
!18 = !DIEnumerator(name: "IPPROTO_ICMP", value: 1)
!19 = !DIEnumerator(name: "IPPROTO_IGMP", value: 2)
!20 = !DIEnumerator(name: "IPPROTO_IPIP", value: 4)
!21 = !DIEnumerator(name: "IPPROTO_TCP", value: 6)
!22 = !DIEnumerator(name: "IPPROTO_EGP", value: 8)
!23 = !DIEnumerator(name: "IPPROTO_PUP", value: 12)
!24 = !DIEnumerator(name: "IPPROTO_UDP", value: 17)
!25 = !DIEnumerator(name: "IPPROTO_IDP", value: 22)
!26 = !DIEnumerator(name: "IPPROTO_TP", value: 29)
!27 = !DIEnumerator(name: "IPPROTO_DCCP", value: 33)
!28 = !DIEnumerator(name: "IPPROTO_IPV6", value: 41)
!29 = !DIEnumerator(name: "IPPROTO_RSVP", value: 46)
!30 = !DIEnumerator(name: "IPPROTO_GRE", value: 47)
!31 = !DIEnumerator(name: "IPPROTO_ESP", value: 50)
!32 = !DIEnumerator(name: "IPPROTO_AH", value: 51)
!33 = !DIEnumerator(name: "IPPROTO_MTP", value: 92)
!34 = !DIEnumerator(name: "IPPROTO_BEETPH", value: 94)
!35 = !DIEnumerator(name: "IPPROTO_ENCAP", value: 98)
!36 = !DIEnumerator(name: "IPPROTO_PIM", value: 103)
!37 = !DIEnumerator(name: "IPPROTO_COMP", value: 108)
!38 = !DIEnumerator(name: "IPPROTO_L2TP", value: 115)
!39 = !DIEnumerator(name: "IPPROTO_SCTP", value: 132)
!40 = !DIEnumerator(name: "IPPROTO_UDPLITE", value: 136)
!41 = !DIEnumerator(name: "IPPROTO_MPLS", value: 137)
!42 = !DIEnumerator(name: "IPPROTO_ETHERNET", value: 143)
!43 = !DIEnumerator(name: "IPPROTO_RAW", value: 255)
!44 = !DIEnumerator(name: "IPPROTO_MPTCP", value: 262)
!45 = !DIEnumerator(name: "IPPROTO_MAX", value: 263)
!46 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 1224, baseType: !7, size: 32, elements: !47)
!47 = !{!48, !49, !50, !51}
!48 = !DIEnumerator(name: "BPF_ANY", value: 0)
!49 = !DIEnumerator(name: "BPF_NOEXIST", value: 1)
!50 = !DIEnumerator(name: "BPF_EXIST", value: 2)
!51 = !DIEnumerator(name: "BPF_F_LOCK", value: 4)
!52 = !{!53, !54, !55, !57, !58, !67, !72, !81}
!53 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!54 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!55 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !56, size: 64)
!56 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!57 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!58 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !59, size: 64)
!59 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "state", file: !60, line: 23, size: 96, elements: !61)
!60 = !DIFile(filename: "./prog.h", directory: "/run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/benchmarks/programs/findstring", checksumkind: CSK_MD5, checksum: "86ee1f43a43606cd00c380e81cf7288b")
!61 = !{!62, !65, !66}
!62 = !DIDerivedType(tag: DW_TAG_member, name: "payload_index", scope: !59, file: !60, line: 24, baseType: !63, size: 32)
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !64, line: 27, baseType: !7)
!64 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!65 = !DIDerivedType(tag: DW_TAG_member, name: "ac_state", scope: !59, file: !60, line: 25, baseType: !63, size: 32, offset: 32)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "matches", scope: !59, file: !60, line: 26, baseType: !63, size: 32, offset: 64)
!67 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !68, size: 64)
!68 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "goto_result", file: !60, line: 29, size: 64, elements: !69)
!69 = !{!70, !71}
!70 = !DIDerivedType(tag: DW_TAG_member, name: "next_state", scope: !68, file: !60, line: 30, baseType: !7, size: 32)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "match", scope: !68, file: !60, line: 31, baseType: !7, size: 32, offset: 32)
!72 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !73, size: 64)
!73 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "data", file: !60, line: 11, size: 128, elements: !74)
!74 = !{!75, !80}
!75 = !DIDerivedType(tag: DW_TAG_member, name: "text", scope: !73, file: !60, line: 12, baseType: !76, size: 80)
!76 = !DICompositeType(tag: DW_TAG_array_type, baseType: !77, size: 80, elements: !78)
!77 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!78 = !{!79}
!79 = !DISubrange(count: 10)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "number", scope: !73, file: !60, line: 13, baseType: !56, size: 32, offset: 96)
!81 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !82, line: 40, baseType: !83)
!82 = !DIFile(filename: "/usr/include/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "4a64d909bcfa62a0a7682c3ac78c6965")
!83 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!84 = !{!85, !200, !205, !210, !215, !220, !0, !222, !238, !252, !268, !281, !289, !295, !302, !307}
!85 = !DIGlobalVariableExpression(var: !86, expr: !DIExpression())
!86 = distinct !DIGlobalVariable(name: "____fmt", scope: !87, file: !3, line: 102, type: !196, isLocal: true, isDefinition: true)
!87 = distinct !DISubprogram(name: "matchPayload", scope: !3, file: !3, line: 56, type: !88, scopeLine: 57, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !99)
!88 = !DISubroutineType(types: !89)
!89 = !{!56, !90}
!90 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !91, size: 64)
!91 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 6141, size: 192, elements: !92)
!92 = !{!93, !94, !95, !96, !97, !98}
!93 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !91, file: !6, line: 6142, baseType: !63, size: 32)
!94 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !91, file: !6, line: 6143, baseType: !63, size: 32, offset: 32)
!95 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !91, file: !6, line: 6144, baseType: !63, size: 32, offset: 64)
!96 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !91, file: !6, line: 6146, baseType: !63, size: 32, offset: 96)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !91, file: !6, line: 6147, baseType: !63, size: 32, offset: 128)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "egress_ifindex", scope: !91, file: !6, line: 6149, baseType: !63, size: 32, offset: 160)
!99 = !{!100, !101, !102, !103, !118, !128, !157, !159, !160, !161, !162, !163, !164, !165, !166, !167, !168, !172, !173, !174, !178, !183, !184, !190, !194, !195}
!100 = !DILocalVariable(name: "ctx", arg: 1, scope: !87, file: !3, line: 56, type: !90)
!101 = !DILocalVariable(name: "data_end", scope: !87, file: !3, line: 58, type: !53)
!102 = !DILocalVariable(name: "data", scope: !87, file: !3, line: 59, type: !53)
!103 = !DILocalVariable(name: "eth", scope: !87, file: !3, line: 60, type: !104)
!104 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !105, size: 64)
!105 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !106, line: 173, size: 112, elements: !107)
!106 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "163f54fb1af2e21fea410f14eb18fa76")
!107 = !{!108, !113, !114}
!108 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !105, file: !106, line: 174, baseType: !109, size: 48)
!109 = !DICompositeType(tag: DW_TAG_array_type, baseType: !110, size: 48, elements: !111)
!110 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!111 = !{!112}
!112 = !DISubrange(count: 6)
!113 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !105, file: !106, line: 175, baseType: !109, size: 48, offset: 48)
!114 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !105, file: !106, line: 176, baseType: !115, size: 16, offset: 96)
!115 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !116, line: 28, baseType: !117)
!116 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "64bcf4b731906682de6e750679b9f4a2")
!117 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !64, line: 24, baseType: !83)
!118 = !DILocalVariable(name: "udp", scope: !87, file: !3, line: 61, type: !119)
!119 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !120, size: 64)
!120 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "udphdr", file: !121, line: 23, size: 64, elements: !122)
!121 = !DIFile(filename: "/usr/include/linux/udp.h", directory: "", checksumkind: CSK_MD5, checksum: "53c0d42e1bf6d93b39151764be2d20fb")
!122 = !{!123, !124, !125, !126}
!123 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !120, file: !121, line: 24, baseType: !115, size: 16)
!124 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !120, file: !121, line: 25, baseType: !115, size: 16, offset: 16)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !120, file: !121, line: 26, baseType: !115, size: 16, offset: 32)
!126 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !120, file: !121, line: 27, baseType: !127, size: 16, offset: 48)
!127 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !116, line: 34, baseType: !117)
!128 = !DILocalVariable(name: "ip", scope: !87, file: !3, line: 62, type: !129)
!129 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !130, size: 64)
!130 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !131, line: 87, size: 160, elements: !132)
!131 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "", checksumkind: CSK_MD5, checksum: "149778ace30a1ff208adc8783fd04b29")
!132 = !{!133, !135, !136, !137, !138, !139, !140, !141, !142, !143}
!133 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !130, file: !131, line: 89, baseType: !134, size: 4, flags: DIFlagBitField, extraData: i64 0)
!134 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !64, line: 21, baseType: !110)
!135 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !130, file: !131, line: 90, baseType: !134, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!136 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !130, file: !131, line: 97, baseType: !134, size: 8, offset: 8)
!137 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !130, file: !131, line: 98, baseType: !115, size: 16, offset: 16)
!138 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !130, file: !131, line: 99, baseType: !115, size: 16, offset: 32)
!139 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !130, file: !131, line: 100, baseType: !115, size: 16, offset: 48)
!140 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !130, file: !131, line: 101, baseType: !134, size: 8, offset: 64)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !130, file: !131, line: 102, baseType: !134, size: 8, offset: 72)
!142 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !130, file: !131, line: 103, baseType: !127, size: 16, offset: 80)
!143 = !DIDerivedType(tag: DW_TAG_member, scope: !130, file: !131, line: 104, baseType: !144, size: 64, offset: 96)
!144 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !130, file: !131, line: 104, size: 64, elements: !145)
!145 = !{!146, !152}
!146 = !DIDerivedType(tag: DW_TAG_member, scope: !144, file: !131, line: 104, baseType: !147, size: 64)
!147 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !144, file: !131, line: 104, size: 64, elements: !148)
!148 = !{!149, !151}
!149 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !147, file: !131, line: 104, baseType: !150, size: 32)
!150 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !116, line: 30, baseType: !63)
!151 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !147, file: !131, line: 104, baseType: !150, size: 32, offset: 32)
!152 = !DIDerivedType(tag: DW_TAG_member, name: "addrs", scope: !144, file: !131, line: 104, baseType: !153, size: 64)
!153 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !144, file: !131, line: 104, size: 64, elements: !154)
!154 = !{!155, !156}
!155 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !153, file: !131, line: 104, baseType: !150, size: 32)
!156 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !153, file: !131, line: 104, baseType: !150, size: 32, offset: 32)
!157 = !DILocalVariable(name: "payload", scope: !87, file: !3, line: 63, type: !158)
!158 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !110, size: 64)
!159 = !DILocalVariable(name: "payload_size", scope: !87, file: !3, line: 85, type: !7)
!160 = !DILocalVariable(name: "key", scope: !87, file: !3, line: 90, type: !77)
!161 = !DILocalVariable(name: "value", scope: !87, file: !3, line: 91, type: !55)
!162 = !DILocalVariable(name: "newstate", scope: !87, file: !3, line: 95, type: !59)
!163 = !DILocalVariable(name: "s", scope: !87, file: !3, line: 96, type: !58)
!164 = !DILocalVariable(name: "ctx_address", scope: !87, file: !3, line: 98, type: !57)
!165 = !DILocalVariable(name: "state_from_map", scope: !87, file: !3, line: 99, type: !58)
!166 = !DILocalVariable(name: "reached_end", scope: !87, file: !3, line: 113, type: !56)
!167 = !DILocalVariable(name: "i", scope: !87, file: !3, line: 114, type: !7)
!168 = !DILocalVariable(name: "payload_access", scope: !169, file: !3, line: 117, type: !7)
!169 = distinct !DILexicalBlock(scope: !170, file: !3, line: 116, column: 5)
!170 = distinct !DILexicalBlock(scope: !171, file: !3, line: 115, column: 5)
!171 = distinct !DILexicalBlock(scope: !87, file: !3, line: 115, column: 5)
!172 = !DILocalVariable(name: "go_from_state", scope: !169, file: !3, line: 125, type: !67)
!173 = !DILocalVariable(name: "ch", scope: !169, file: !3, line: 130, type: !7)
!174 = !DILocalVariable(name: "j", scope: !175, file: !3, line: 148, type: !56)
!175 = distinct !DILexicalBlock(scope: !176, file: !3, line: 148, column: 9)
!176 = distinct !DILexicalBlock(scope: !177, file: !3, line: 147, column: 21)
!177 = distinct !DILexicalBlock(scope: !87, file: !3, line: 147, column: 8)
!178 = !DILocalVariable(name: "key", scope: !179, file: !3, line: 152, type: !56)
!179 = distinct !DILexicalBlock(scope: !180, file: !3, line: 151, column: 13)
!180 = distinct !DILexicalBlock(scope: !181, file: !3, line: 150, column: 17)
!181 = distinct !DILexicalBlock(scope: !182, file: !3, line: 149, column: 9)
!182 = distinct !DILexicalBlock(scope: !175, file: !3, line: 148, column: 9)
!183 = !DILocalVariable(name: "word", scope: !179, file: !3, line: 153, type: !72)
!184 = !DILocalVariable(name: "fmt", scope: !185, file: !3, line: 156, type: !187)
!185 = distinct !DILexicalBlock(scope: !186, file: !3, line: 154, column: 26)
!186 = distinct !DILexicalBlock(scope: !179, file: !3, line: 154, column: 20)
!187 = !DICompositeType(tag: DW_TAG_array_type, baseType: !77, size: 480, elements: !188)
!188 = !{!189}
!189 = !DISubrange(count: 60)
!190 = !DILocalVariable(name: "clean_or_not", scope: !176, file: !3, line: 162, type: !191)
!191 = !DICompositeType(tag: DW_TAG_array_type, baseType: !77, size: 112, elements: !192)
!192 = !{!193}
!193 = !DISubrange(count: 14)
!194 = !DILocalVariable(name: "pass_or_not", scope: !176, file: !3, line: 163, type: !56)
!195 = !DILocalVariable(name: "key", scope: !176, file: !3, line: 173, type: !57)
!196 = !DICompositeType(tag: DW_TAG_array_type, baseType: !197, size: 384, elements: !198)
!197 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !77)
!198 = !{!199}
!199 = !DISubrange(count: 48)
!200 = !DIGlobalVariableExpression(var: !201, expr: !DIExpression())
!201 = distinct !DIGlobalVariable(name: "____fmt", scope: !87, file: !3, line: 104, type: !202, isLocal: true, isDefinition: true)
!202 = !DICompositeType(tag: DW_TAG_array_type, baseType: !197, size: 408, elements: !203)
!203 = !{!204}
!204 = !DISubrange(count: 51)
!205 = !DIGlobalVariableExpression(var: !206, expr: !DIExpression())
!206 = distinct !DIGlobalVariable(scope: null, file: !3, line: 166, type: !207, isLocal: true, isDefinition: true)
!207 = !DICompositeType(tag: DW_TAG_array_type, baseType: !77, size: 104, elements: !208)
!208 = !{!209}
!209 = !DISubrange(count: 13)
!210 = !DIGlobalVariableExpression(var: !211, expr: !DIExpression())
!211 = distinct !DIGlobalVariable(scope: null, file: !3, line: 169, type: !212, isLocal: true, isDefinition: true)
!212 = !DICompositeType(tag: DW_TAG_array_type, baseType: !77, size: 96, elements: !213)
!213 = !{!214}
!214 = !DISubrange(count: 12)
!215 = !DIGlobalVariableExpression(var: !216, expr: !DIExpression())
!216 = distinct !DIGlobalVariable(name: "____fmt", scope: !87, file: !3, line: 172, type: !217, isLocal: true, isDefinition: true)
!217 = !DICompositeType(tag: DW_TAG_array_type, baseType: !197, size: 296, elements: !218)
!218 = !{!219}
!219 = !DISubrange(count: 37)
!220 = !DIGlobalVariableExpression(var: !221, expr: !DIExpression())
!221 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 184, type: !207, isLocal: false, isDefinition: true)
!222 = !DIGlobalVariableExpression(var: !223, expr: !DIExpression())
!223 = distinct !DIGlobalVariable(name: "strings", scope: !2, file: !3, line: 24, type: !224, isLocal: false, isDefinition: true)
!224 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 18, size: 256, elements: !225)
!225 = !{!226, !231, !236, !237}
!226 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !224, file: !3, line: 20, baseType: !227, size: 64)
!227 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !228, size: 64)
!228 = !DICompositeType(tag: DW_TAG_array_type, baseType: !56, size: 64, elements: !229)
!229 = !{!230}
!230 = !DISubrange(count: 2)
!231 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !224, file: !3, line: 21, baseType: !232, size: 64, offset: 64)
!232 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !233, size: 64)
!233 = !DICompositeType(tag: DW_TAG_array_type, baseType: !56, size: 160, elements: !234)
!234 = !{!235}
!235 = !DISubrange(count: 5)
!236 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !224, file: !3, line: 22, baseType: !55, size: 64, offset: 128)
!237 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !224, file: !3, line: 23, baseType: !72, size: 64, offset: 192)
!238 = !DIGlobalVariableExpression(var: !239, expr: !DIExpression())
!239 = distinct !DIGlobalVariable(name: "goto_func", scope: !2, file: !3, line: 32, type: !240, isLocal: false, isDefinition: true)
!240 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 26, size: 256, elements: !241)
!241 = !{!242, !243, !246, !247}
!242 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !240, file: !3, line: 28, baseType: !227, size: 64)
!243 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !240, file: !3, line: 29, baseType: !244, size: 64, offset: 64)
!244 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !245, size: 64)
!245 = !DICompositeType(tag: DW_TAG_array_type, baseType: !56, size: 1632, elements: !203)
!246 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !240, file: !3, line: 30, baseType: !55, size: 64, offset: 128)
!247 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !240, file: !3, line: 31, baseType: !248, size: 64, offset: 192)
!248 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !249, size: 64)
!249 = !DICompositeType(tag: DW_TAG_array_type, baseType: !68, size: 1664, elements: !250)
!250 = !{!251}
!251 = !DISubrange(count: 26)
!252 = !DIGlobalVariableExpression(var: !253, expr: !DIExpression())
!253 = distinct !DIGlobalVariable(name: "progs", scope: !2, file: !3, line: 40, type: !254, isLocal: false, isDefinition: true)
!254 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 34, size: 256, elements: !255)
!255 = !{!256, !261, !266, !267}
!256 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !254, file: !3, line: 36, baseType: !257, size: 64)
!257 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !258, size: 64)
!258 = !DICompositeType(tag: DW_TAG_array_type, baseType: !56, size: 96, elements: !259)
!259 = !{!260}
!260 = !DISubrange(count: 3)
!261 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !254, file: !3, line: 37, baseType: !262, size: 64, offset: 64)
!262 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !263, size: 64)
!263 = !DICompositeType(tag: DW_TAG_array_type, baseType: !56, size: 32, elements: !264)
!264 = !{!265}
!265 = !DISubrange(count: 1)
!266 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !254, file: !3, line: 38, baseType: !55, size: 64, offset: 128)
!267 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !254, file: !3, line: 39, baseType: !55, size: 64, offset: 192)
!268 = !DIGlobalVariableExpression(var: !269, expr: !DIExpression())
!269 = distinct !DIGlobalVariable(name: "state_map", scope: !2, file: !3, line: 48, type: !270, isLocal: false, isDefinition: true)
!270 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 42, size: 256, elements: !271)
!271 = !{!272, !273, !278, !280}
!272 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !270, file: !3, line: 44, baseType: !262, size: 64)
!273 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !270, file: !3, line: 45, baseType: !274, size: 64, offset: 64)
!274 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !275, size: 64)
!275 = !DICompositeType(tag: DW_TAG_array_type, baseType: !56, size: 32000, elements: !276)
!276 = !{!277}
!277 = !DISubrange(count: 1000)
!278 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !270, file: !3, line: 46, baseType: !279, size: 64, offset: 128)
!279 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !57, size: 64)
!280 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !270, file: !3, line: 47, baseType: !58, size: 64, offset: 192)
!281 = !DIGlobalVariableExpression(var: !282, expr: !DIExpression())
!282 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !283, line: 51, type: !284, isLocal: true, isDefinition: true)
!283 = !DIFile(filename: "../../libs/libbpf/src/root/usr/include/bpf/bpf_helper_defs.h", directory: "/run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/benchmarks/programs/findstring", checksumkind: CSK_MD5, checksum: "ad8ff3755106b533b446159c410c596d")
!284 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !285, size: 64)
!285 = !DISubroutineType(types: !286)
!286 = !{!53, !53, !287}
!287 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !288, size: 64)
!288 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!289 = !DIGlobalVariableExpression(var: !290, expr: !DIExpression())
!290 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !283, line: 172, type: !291, isLocal: true, isDefinition: true)
!291 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !292, size: 64)
!292 = !DISubroutineType(types: !293)
!293 = !{!54, !294, !63, null}
!294 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !197, size: 64)
!295 = !DIGlobalVariableExpression(var: !296, expr: !DIExpression())
!296 = distinct !DIGlobalVariable(name: "bpf_map_update_elem", scope: !2, file: !283, line: 73, type: !297, isLocal: true, isDefinition: true)
!297 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !298, size: 64)
!298 = !DISubroutineType(types: !299)
!299 = !{!54, !53, !287, !287, !300}
!300 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !64, line: 31, baseType: !301)
!301 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!302 = !DIGlobalVariableExpression(var: !303, expr: !DIExpression())
!303 = distinct !DIGlobalVariable(name: "bpf_map_delete_elem", scope: !2, file: !283, line: 83, type: !304, isLocal: true, isDefinition: true)
!304 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !305, size: 64)
!305 = !DISubroutineType(types: !306)
!306 = !{!54, !53, !287}
!307 = !DIGlobalVariableExpression(var: !308, expr: !DIExpression())
!308 = distinct !DIGlobalVariable(name: "bpf_tail_call", scope: !2, file: !283, line: 322, type: !309, isLocal: true, isDefinition: true)
!309 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !310, size: 64)
!310 = !DISubroutineType(types: !311)
!311 = !{!54, !53, !53, !63}
!312 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 10, size: 256, elements: !313)
!313 = !{!314, !315, !316, !318}
!314 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !312, file: !3, line: 12, baseType: !262, size: 64)
!315 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !312, file: !3, line: 13, baseType: !262, size: 64, offset: 64)
!316 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !312, file: !3, line: 14, baseType: !317, size: 64, offset: 128)
!317 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !77, size: 64)
!318 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !312, file: !3, line: 15, baseType: !55, size: 64, offset: 192)
!319 = !{i32 7, !"Dwarf Version", i32 5}
!320 = !{i32 2, !"Debug Info Version", i32 3}
!321 = !{i32 1, !"wchar_size", i32 4}
!322 = !{i32 7, !"frame-pointer", i32 2}
!323 = !{!"clang version 15.0.7"}
!324 = !DILocation(line: 0, scope: !87)
!325 = !DILocation(line: 58, column: 41, scope: !87)
!326 = !{!327, !328, i64 4}
!327 = !{!"xdp_md", !328, i64 0, !328, i64 4, !328, i64 8, !328, i64 12, !328, i64 16, !328, i64 20}
!328 = !{!"int", !329, i64 0}
!329 = !{!"omnipotent char", !330, i64 0}
!330 = !{!"Simple C/C++ TBAA"}
!331 = !DILocation(line: 58, column: 30, scope: !87)
!332 = !DILocation(line: 58, column: 22, scope: !87)
!333 = !DILocation(line: 59, column: 37, scope: !87)
!334 = !{!327, !328, i64 0}
!335 = !DILocation(line: 59, column: 26, scope: !87)
!336 = !DILocation(line: 59, column: 18, scope: !87)
!337 = !DILocation(line: 67, column: 21, scope: !338)
!338 = distinct !DILexicalBlock(scope: !87, file: !3, line: 67, column: 9)
!339 = !DILocation(line: 67, column: 36, scope: !338)
!340 = !DILocation(line: 67, column: 9, scope: !87)
!341 = !DILocation(line: 76, column: 13, scope: !342)
!342 = distinct !DILexicalBlock(scope: !87, file: !3, line: 76, column: 9)
!343 = !{!344, !329, i64 9}
!344 = !{!"iphdr", !329, i64 0, !329, i64 0, !329, i64 1, !345, i64 2, !345, i64 4, !345, i64 6, !329, i64 8, !329, i64 9, !345, i64 10, !329, i64 12}
!345 = !{!"short", !329, i64 0}
!346 = !DILocation(line: 76, column: 22, scope: !342)
!347 = !DILocation(line: 76, column: 9, scope: !87)
!348 = !DILocation(line: 81, column: 21, scope: !349)
!349 = distinct !DILexicalBlock(scope: !87, file: !3, line: 81, column: 9)
!350 = !DILocation(line: 81, column: 36, scope: !349)
!351 = !DILocation(line: 81, column: 9, scope: !87)
!352 = !DILocation(line: 85, column: 33, scope: !87)
!353 = !{!354, !345, i64 4}
!354 = !{!"udphdr", !345, i64 0, !345, i64 2, !345, i64 4, !345, i64 6}
!355 = !DILocation(line: 85, column: 49, scope: !87)
!356 = !DILocation(line: 86, column: 25, scope: !357)
!357 = distinct !DILexicalBlock(scope: !87, file: !3, line: 86, column: 9)
!358 = !DILocation(line: 86, column: 40, scope: !357)
!359 = !DILocation(line: 86, column: 9, scope: !87)
!360 = !DILocation(line: 90, column: 5, scope: !87)
!361 = !DILocation(line: 90, column: 10, scope: !87)
!362 = !{!329, !329, i64 0}
!363 = !DILocation(line: 91, column: 25, scope: !87)
!364 = !DILocation(line: 92, column: 15, scope: !365)
!365 = distinct !DILexicalBlock(scope: !87, file: !3, line: 92, column: 9)
!366 = !DILocation(line: 92, column: 23, scope: !365)
!367 = !DILocation(line: 92, column: 31, scope: !365)
!368 = !{!354, !345, i64 2}
!369 = !DILocation(line: 92, column: 39, scope: !365)
!370 = !{!328, !328, i64 0}
!371 = !DILocation(line: 92, column: 36, scope: !365)
!372 = !DILocation(line: 92, column: 9, scope: !87)
!373 = !DILocation(line: 95, column: 5, scope: !87)
!374 = !DILocation(line: 95, column: 18, scope: !87)
!375 = !DILocation(line: 98, column: 5, scope: !87)
!376 = !DILocation(line: 98, column: 33, scope: !87)
!377 = !DILocation(line: 98, column: 19, scope: !87)
!378 = !{!379, !379, i64 0}
!379 = !{!"long", !329, i64 0}
!380 = !DILocation(line: 99, column: 52, scope: !87)
!381 = !DILocation(line: 100, column: 8, scope: !382)
!382 = distinct !DILexicalBlock(scope: !87, file: !3, line: 100, column: 8)
!383 = !DILocation(line: 100, column: 8, scope: !87)
!384 = !DILocation(line: 102, column: 9, scope: !385)
!385 = distinct !DILexicalBlock(scope: !386, file: !3, line: 102, column: 9)
!386 = distinct !DILexicalBlock(scope: !382, file: !3, line: 100, column: 24)
!387 = !{!388, !328, i64 0}
!388 = !{!"state", !328, i64 0, !328, i64 4, !328, i64 8}
!389 = !DILocation(line: 103, column: 5, scope: !386)
!390 = !DILocation(line: 104, column: 9, scope: !391)
!391 = distinct !DILexicalBlock(scope: !392, file: !3, line: 104, column: 9)
!392 = distinct !DILexicalBlock(scope: !382, file: !3, line: 103, column: 12)
!393 = !DILocation(line: 106, column: 21, scope: !392)
!394 = !{!388, !328, i64 4}
!395 = !DILocation(line: 107, column: 26, scope: !392)
!396 = !DILocation(line: 108, column: 20, scope: !392)
!397 = !{!388, !328, i64 8}
!398 = !DILocation(line: 110, column: 9, scope: !392)
!399 = !DILocation(line: 115, column: 5, scope: !171)
!400 = !DILocation(line: 117, column: 38, scope: !169)
!401 = !DILocation(line: 117, column: 52, scope: !169)
!402 = !DILocation(line: 0, scope: !169)
!403 = !DILocation(line: 119, column: 28, scope: !404)
!404 = distinct !DILexicalBlock(scope: !169, file: !3, line: 119, column: 13)
!405 = !DILocation(line: 119, column: 36, scope: !404)
!406 = !DILocation(line: 119, column: 55, scope: !404)
!407 = !DILocation(line: 119, column: 72, scope: !404)
!408 = !DILocation(line: 119, column: 76, scope: !404)
!409 = !DILocation(line: 119, column: 13, scope: !169)
!410 = !DILocation(line: 125, column: 66, scope: !169)
!411 = !DILocation(line: 126, column: 13, scope: !412)
!412 = distinct !DILexicalBlock(scope: !169, file: !3, line: 126, column: 12)
!413 = !DILocation(line: 126, column: 12, scope: !169)
!414 = !DILocation(line: 130, column: 23, scope: !169)
!415 = !DILocation(line: 130, column: 47, scope: !169)
!416 = !DILocation(line: 132, column: 15, scope: !417)
!417 = distinct !DILexicalBlock(scope: !169, file: !3, line: 132, column: 12)
!418 = !DILocation(line: 132, column: 12, scope: !169)
!419 = !DILocation(line: 133, column: 25, scope: !420)
!420 = distinct !DILexicalBlock(scope: !417, file: !3, line: 132, column: 24)
!421 = !DILocation(line: 134, column: 13, scope: !420)
!422 = !DILocation(line: 137, column: 23, scope: !169)
!423 = !DILocation(line: 137, column: 41, scope: !169)
!424 = !{!425, !328, i64 0}
!425 = !{!"goto_result", !328, i64 0, !328, i64 4}
!426 = !DILocation(line: 137, column: 21, scope: !169)
!427 = !DILocation(line: 139, column: 31, scope: !428)
!428 = distinct !DILexicalBlock(scope: !169, file: !3, line: 139, column: 13)
!429 = !{!425, !328, i64 4}
!430 = !DILocation(line: 139, column: 37, scope: !428)
!431 = !DILocation(line: 139, column: 13, scope: !169)
!432 = !DILocation(line: 144, column: 20, scope: !169)
!433 = !DILocation(line: 145, column: 5, scope: !170)
!434 = !DILocation(line: 115, column: 28, scope: !170)
!435 = !DILocation(line: 115, column: 19, scope: !170)
!436 = distinct !{!436, !399, !437, !438}
!437 = !DILocation(line: 145, column: 5, scope: !171)
!438 = !{!"llvm.loop.mustprogress"}
!439 = !DILocation(line: 0, scope: !175)
!440 = !DILocation(line: 150, column: 20, scope: !180)
!441 = !DILocation(line: 150, column: 28, scope: !180)
!442 = !DILocation(line: 150, column: 17, scope: !181)
!443 = !DILocation(line: 152, column: 17, scope: !179)
!444 = !DILocation(line: 0, scope: !179)
!445 = !DILocation(line: 152, column: 21, scope: !179)
!446 = !DILocation(line: 153, column: 51, scope: !179)
!447 = !DILocation(line: 154, column: 20, scope: !186)
!448 = !DILocation(line: 154, column: 20, scope: !179)
!449 = !DILocation(line: 155, column: 27, scope: !185)
!450 = !DILocation(line: 155, column: 33, scope: !185)
!451 = !{!452, !328, i64 12}
!452 = !{!"data", !329, i64 0, !328, i64 12}
!453 = !DILocation(line: 156, column: 21, scope: !185)
!454 = !DILocation(line: 156, column: 26, scope: !185)
!455 = !DILocation(line: 157, column: 73, scope: !185)
!456 = !DILocation(line: 157, column: 21, scope: !185)
!457 = !DILocation(line: 158, column: 17, scope: !186)
!458 = !DILocation(line: 158, column: 17, scope: !185)
!459 = !DILocation(line: 159, column: 13, scope: !180)
!460 = !DILocation(line: 159, column: 13, scope: !179)
!461 = !DILocation(line: 164, column: 15, scope: !462)
!462 = distinct !DILexicalBlock(scope: !176, file: !3, line: 164, column: 12)
!463 = !DILocation(line: 162, column: 9, scope: !176)
!464 = !DILocation(line: 162, column: 14, scope: !176)
!465 = !DILocation(line: 164, column: 12, scope: !462)
!466 = !DILocation(line: 164, column: 12, scope: !176)
!467 = !DILocation(line: 0, scope: !176)
!468 = !DILocation(line: 166, column: 13, scope: !469)
!469 = distinct !DILexicalBlock(scope: !462, file: !3, line: 164, column: 24)
!470 = !DILocation(line: 167, column: 9, scope: !469)
!471 = !DILocation(line: 169, column: 13, scope: !472)
!472 = distinct !DILexicalBlock(scope: !462, file: !3, line: 167, column: 16)
!473 = !DILocation(line: 0, scope: !462)
!474 = !DILocation(line: 172, column: 9, scope: !475)
!475 = distinct !DILexicalBlock(scope: !176, file: !3, line: 172, column: 9)
!476 = !DILocation(line: 173, column: 9, scope: !176)
!477 = !DILocation(line: 173, column: 23, scope: !176)
!478 = !DILocation(line: 174, column: 9, scope: !176)
!479 = !DILocation(line: 177, column: 5, scope: !177)
!480 = !DILocation(line: 0, scope: !171)
!481 = !DILocation(line: 178, column: 26, scope: !482)
!482 = distinct !DILexicalBlock(scope: !177, file: !3, line: 177, column: 12)
!483 = !DILocation(line: 179, column: 9, scope: !482)
!484 = !DILocation(line: 180, column: 9, scope: !482)
!485 = !DILocation(line: 0, scope: !177)
!486 = !DILocation(line: 182, column: 1, scope: !87)
