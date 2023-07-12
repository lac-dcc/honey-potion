; ModuleID = '/home/vinicius/honey-potion/test_cases/lib/src/GetPID.bpf.c'
source_filename = "/home/vinicius/honey-potion/test_cases/lib/src/GetPID.bpf.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.anon = type { ptr, ptr, ptr, ptr }
%struct.anon.0 = type { ptr, ptr, ptr, ptr }
%struct.anon.1 = type { ptr, ptr, ptr, ptr }
%struct.anon.2 = type { ptr, ptr, ptr, ptr }
%struct.anon.3 = type { ptr, ptr, ptr, ptr }
%struct.anon.4 = type { ptr, ptr, ptr, ptr }
%struct.OpResult = type { %struct.Generic, i32, [150 x i8] }
%struct.Generic = type { i32, %union.ElixirValue }
%union.ElixirValue = type { i64, [8 x i8] }

@LICENSE = dso_local global [13 x i8] c"Dual BSD/GPL\00", section "license", align 1, !dbg !0
@string_pool_map = dso_local global %struct.anon zeroinitializer, section ".maps", align 8, !dbg !50
@.str = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4, !dbg !20
@string_pool_index_map = dso_local global %struct.anon.0 zeroinitializer, section ".maps", align 8, !dbg !72
@.str.1 = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool index, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4, !dbg !27
@.str.2 = private unnamed_addr constant [4 x i8] c"nil\00", align 1, !dbg !29
@.str.3 = private unnamed_addr constant [6 x i8] c"false\00", align 1, !dbg !34
@heap_map = dso_local global %struct.anon.1 zeroinitializer, section ".maps", align 8, !dbg !100
@.str.5 = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access heap map, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4, !dbg !44
@heap_index_map = dso_local global %struct.anon.2 zeroinitializer, section ".maps", align 8, !dbg !112
@.str.6 = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access heap map index, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4, !dbg !46
@tuple_pool_map = dso_local global %struct.anon.3 zeroinitializer, section ".maps", align 8, !dbg !80
@tuple_pool_index_map = dso_local global %struct.anon.4 zeroinitializer, section ".maps", align 8, !dbg !92
@__const.main_func.____fmt = private unnamed_addr constant [16 x i8] c"Current PID: %d\00", align 1
@__const.main_func.____fmt.8 = private unnamed_addr constant [7 x i8] c"** %s\0A\00", align 1
@llvm.compiler.used = appending global [8 x ptr] [ptr @LICENSE, ptr @heap_index_map, ptr @heap_map, ptr @main_func, ptr @string_pool_index_map, ptr @string_pool_map, ptr @tuple_pool_index_map, ptr @tuple_pool_map], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @main_func(ptr nocapture readnone %0) #0 section "tracepoint/syscalls/sys_enter_kill" !dbg !154 {
  call void @llvm.dbg.declare(metadata ptr undef, metadata !168, metadata !DIExpression()), !dbg !247
  call void @llvm.dbg.declare(metadata ptr undef, metadata !176, metadata !DIExpression()), !dbg !248
  call void @llvm.dbg.declare(metadata ptr undef, metadata !177, metadata !DIExpression()), !dbg !249
  %2 = alloca %struct.OpResult, align 8
  %3 = alloca i32, align 4
  %4 = alloca [16 x i8], align 1
  %5 = alloca [7 x i8], align 1
  call void @llvm.dbg.value(metadata ptr poison, metadata !167, metadata !DIExpression()), !dbg !250
  call void @llvm.lifetime.start.p0(i64 184, ptr nonnull %2) #6, !dbg !251
  call void @llvm.dbg.declare(metadata ptr %2, metadata !178, metadata !DIExpression()), !dbg !252
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(184) %2, i8 0, i64 184, i1 false), !dbg !252
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #6, !dbg !253
  call void @llvm.dbg.value(metadata i32 0, metadata !218, metadata !DIExpression()), !dbg !250
  store i32 0, ptr %3, align 4, !dbg !254, !tbaa !255
  call void @llvm.dbg.value(metadata ptr %3, metadata !218, metadata !DIExpression(DW_OP_deref)), !dbg !250
  %6 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @string_pool_map, ptr noundef nonnull %3) #6, !dbg !259
  call void @llvm.dbg.value(metadata ptr %6, metadata !219, metadata !DIExpression()), !dbg !250
  %7 = icmp eq ptr %6, null, !dbg !260
  br i1 %7, label %8, label %11, !dbg !262

8:                                                ; preds = %1
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %2, i8 0, i64 24, i1 false), !dbg !263
  %9 = getelementptr inbounds i8, ptr %2, i64 24, !dbg !265
  store i32 1, ptr %9, align 8, !dbg !265, !tbaa.struct !266
  %10 = getelementptr inbounds i8, ptr %2, i64 28, !dbg !265
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %10, ptr noundef nonnull align 4 dereferenceable(150) @.str, i64 150, i1 false), !dbg !265, !tbaa.struct !268
  br label %46, !dbg !269

11:                                               ; preds = %1
  call void @llvm.dbg.value(metadata ptr %3, metadata !218, metadata !DIExpression(DW_OP_deref)), !dbg !250
  %12 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @string_pool_index_map, ptr noundef nonnull %3) #6, !dbg !270
  call void @llvm.dbg.value(metadata ptr %12, metadata !222, metadata !DIExpression()), !dbg !250
  %13 = icmp eq ptr %12, null, !dbg !271
  br i1 %13, label %14, label %17, !dbg !273

14:                                               ; preds = %11
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %2, i8 0, i64 24, i1 false), !dbg !274
  %15 = getelementptr inbounds i8, ptr %2, i64 24, !dbg !276
  store i32 1, ptr %15, align 8, !dbg !276, !tbaa.struct !266
  %16 = getelementptr inbounds i8, ptr %2, i64 28, !dbg !276
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %16, ptr noundef nonnull align 4 dereferenceable(150) @.str.1, i64 150, i1 false), !dbg !276, !tbaa.struct !268
  br label %46, !dbg !277

17:                                               ; preds = %11
  store i32 0, ptr %12, align 4, !dbg !278, !tbaa !255
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(3) %6, ptr noundef nonnull align 1 dereferenceable(3) @.str.2, i64 3, i1 false), !dbg !279
  %18 = getelementptr inbounds i8, ptr %6, i64 3, !dbg !280
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %18, ptr noundef nonnull align 1 dereferenceable(5) @.str.3, i64 5, i1 false), !dbg !281
  %19 = getelementptr inbounds i8, ptr %6, i64 8, !dbg !282
  store i32 1702195828, ptr %19, align 1, !dbg !283
  call void @llvm.dbg.value(metadata ptr %3, metadata !218, metadata !DIExpression(DW_OP_deref)), !dbg !250
  %20 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @heap_map, ptr noundef nonnull %3) #6, !dbg !284
  call void @llvm.dbg.value(metadata ptr %20, metadata !224, metadata !DIExpression()), !dbg !250
  %21 = icmp eq ptr %20, null, !dbg !285
  br i1 %21, label %22, label %25, !dbg !287

22:                                               ; preds = %17
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %2, i8 0, i64 24, i1 false), !dbg !288
  %23 = getelementptr inbounds i8, ptr %2, i64 24, !dbg !290
  store i32 1, ptr %23, align 8, !dbg !290, !tbaa.struct !266
  %24 = getelementptr inbounds i8, ptr %2, i64 28, !dbg !290
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %24, ptr noundef nonnull align 4 dereferenceable(150) @.str.5, i64 150, i1 false), !dbg !290, !tbaa.struct !268
  br label %46, !dbg !291

25:                                               ; preds = %17
  call void @llvm.dbg.value(metadata ptr %3, metadata !218, metadata !DIExpression(DW_OP_deref)), !dbg !250
  %26 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @heap_index_map, ptr noundef nonnull %3) #6, !dbg !292
  call void @llvm.dbg.value(metadata ptr %26, metadata !229, metadata !DIExpression()), !dbg !250
  %27 = icmp eq ptr %26, null, !dbg !293
  br i1 %27, label %28, label %31, !dbg !295

28:                                               ; preds = %25
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %2, i8 0, i64 24, i1 false), !dbg !296
  %29 = getelementptr inbounds i8, ptr %2, i64 24, !dbg !298
  store i32 1, ptr %29, align 8, !dbg !298, !tbaa.struct !266
  %30 = getelementptr inbounds i8, ptr %2, i64 28, !dbg !298
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %30, ptr noundef nonnull align 4 dereferenceable(150) @.str.6, i64 150, i1 false), !dbg !298, !tbaa.struct !268
  br label %46, !dbg !299

31:                                               ; preds = %25
  store i32 0, ptr %26, align 4, !dbg !300, !tbaa !255
  call void @llvm.dbg.value(metadata ptr %3, metadata !218, metadata !DIExpression(DW_OP_deref)), !dbg !250
  %32 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tuple_pool_map, ptr noundef nonnull %3) #6, !dbg !301
  call void @llvm.dbg.value(metadata ptr %32, metadata !230, metadata !DIExpression()), !dbg !250
  %33 = icmp eq ptr %32, null, !dbg !302
  br i1 %33, label %34, label %37, !dbg !304

34:                                               ; preds = %31
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %2, i8 0, i64 24, i1 false), !dbg !305
  %35 = getelementptr inbounds i8, ptr %2, i64 24, !dbg !307
  store i32 1, ptr %35, align 8, !dbg !307, !tbaa.struct !266
  %36 = getelementptr inbounds i8, ptr %2, i64 28, !dbg !307
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %36, ptr noundef nonnull align 4 dereferenceable(150) @.str, i64 150, i1 false), !dbg !307, !tbaa.struct !268
  br label %46, !dbg !308

37:                                               ; preds = %31
  call void @llvm.dbg.value(metadata ptr %3, metadata !218, metadata !DIExpression(DW_OP_deref)), !dbg !250
  %38 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tuple_pool_index_map, ptr noundef nonnull %3) #6, !dbg !309
  call void @llvm.dbg.value(metadata ptr %38, metadata !233, metadata !DIExpression()), !dbg !250
  %39 = icmp eq ptr %38, null, !dbg !310
  br i1 %39, label %40, label %43, !dbg !312

40:                                               ; preds = %37
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %2, i8 0, i64 24, i1 false), !dbg !313
  %41 = getelementptr inbounds i8, ptr %2, i64 24, !dbg !315
  store i32 1, ptr %41, align 8, !dbg !315, !tbaa.struct !266
  %42 = getelementptr inbounds i8, ptr %2, i64 28, !dbg !315
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %42, ptr noundef nonnull align 4 dereferenceable(150) @.str.1, i64 150, i1 false), !dbg !315, !tbaa.struct !268
  br label %46, !dbg !316

43:                                               ; preds = %37
  store i32 0, ptr %38, align 4, !dbg !317, !tbaa !255
  call void @llvm.dbg.value(metadata i32 2, metadata !234, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !250
  %44 = call i64 inttoptr (i64 14 to ptr)() #6, !dbg !318
  call void @llvm.dbg.value(metadata i64 %44, metadata !234, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !250
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %4) #6, !dbg !319
  call void @llvm.dbg.declare(metadata ptr %4, metadata !235, metadata !DIExpression()), !dbg !319
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(16) %4, ptr noundef nonnull align 1 dereferenceable(16) @__const.main_func.____fmt, i64 16, i1 false), !dbg !319
  %45 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull %4, i32 noundef 16, i64 noundef %44) #6, !dbg !319
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %4) #6, !dbg !320
  call void @llvm.dbg.value(metadata i32 2, metadata !240, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !250
  call void @llvm.dbg.value(metadata i32 undef, metadata !240, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !250
  call void @llvm.dbg.value(metadata i64 0, metadata !240, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !250
  call void @llvm.dbg.value(metadata i64 undef, metadata !240, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !250
  br label %49, !dbg !321

46:                                               ; preds = %40, %34, %28, %22, %14, %8
  call void @llvm.dbg.label(metadata !246), !dbg !322
  call void @llvm.lifetime.start.p0(i64 7, ptr nonnull %5) #6, !dbg !323
  call void @llvm.dbg.declare(metadata ptr %5, metadata !241, metadata !DIExpression()), !dbg !323
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(7) %5, ptr noundef nonnull align 1 dereferenceable(7) @__const.main_func.____fmt.8, i64 7, i1 false), !dbg !323
  %47 = getelementptr inbounds %struct.OpResult, ptr %2, i64 0, i32 2, !dbg !323
  %48 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull %5, i32 noundef 7, ptr noundef nonnull %47) #6, !dbg !323
  call void @llvm.lifetime.end.p0(i64 7, ptr nonnull %5) #6, !dbg !324
  br label %49, !dbg !325

49:                                               ; preds = %46, %43
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #6, !dbg !326
  call void @llvm.lifetime.end.p0(i64 184, ptr nonnull %2) #6, !dbg !326
  ret i32 0, !dbg !326
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #2

; Function Attrs: argmemonly mustprogress nocallback nofree nounwind willreturn writeonly
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #3

; Function Attrs: argmemonly mustprogress nocallback nofree nounwind willreturn
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #4

; Function Attrs: argmemonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #5

attributes #0 = { nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly mustprogress nocallback nofree nosync nounwind willreturn }
attributes #3 = { argmemonly mustprogress nocallback nofree nounwind willreturn writeonly }
attributes #4 = { argmemonly mustprogress nocallback nofree nounwind willreturn }
attributes #5 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!149, !150, !151, !152}
!llvm.ident = !{!153}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "LICENSE", scope: !2, file: !22, line: 24, type: !146, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 15.0.7", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !19, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/vinicius/honey-potion/test_cases/lib/src/GetPID.bpf.c", directory: "/home/vinicius/honey-potion/test_cases/lib", checksumkind: CSK_MD5, checksum: "c796c125c565e35412d78f84d7c256d1")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "Type", file: !6, line: 40, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "_build/dev/lib/honey/priv/c_boilerplates/runtime_generic.bpf.h", directory: "/home/vinicius/honey-potion/test_cases", checksumkind: CSK_MD5, checksum: "699e26b6150612b5cee9098b6ccdafaf")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14, !15, !16, !17, !18}
!9 = !DIEnumerator(name: "INVALID_TYPE", value: 0)
!10 = !DIEnumerator(name: "PATTERN_M", value: 1)
!11 = !DIEnumerator(name: "INTEGER", value: 2)
!12 = !DIEnumerator(name: "DOUBLE", value: 3)
!13 = !DIEnumerator(name: "STRING", value: 4)
!14 = !DIEnumerator(name: "ATOM", value: 5)
!15 = !DIEnumerator(name: "TUPLE", value: 6)
!16 = !DIEnumerator(name: "LIST", value: 7)
!17 = !DIEnumerator(name: "STRUCT", value: 8)
!18 = !DIEnumerator(name: "TYPE_Syscalls_enter_kill_arg", value: 9)
!19 = !{!0, !20, !27, !29, !34, !39, !44, !46, !48, !50, !72, !80, !92, !100, !112, !120, !129, !137}
!20 = !DIGlobalVariableExpression(var: !21, expr: !DIExpression())
!21 = distinct !DIGlobalVariable(scope: null, file: !22, line: 41, type: !23, isLocal: true, isDefinition: true)
!22 = !DIFile(filename: "src/GetPID.bpf.c", directory: "/home/vinicius/honey-potion/test_cases/lib", checksumkind: CSK_MD5, checksum: "c796c125c565e35412d78f84d7c256d1")
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 1200, elements: !25)
!24 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!25 = !{!26}
!26 = !DISubrange(count: 150)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(scope: null, file: !22, line: 48, type: !23, isLocal: true, isDefinition: true)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !22, line: 53, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 32, elements: !32)
!32 = !{!33}
!33 = !DISubrange(count: 4)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(scope: null, file: !22, line: 54, type: !36, isLocal: true, isDefinition: true)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 48, elements: !37)
!37 = !{!38}
!38 = !DISubrange(count: 6)
!39 = !DIGlobalVariableExpression(var: !40, expr: !DIExpression())
!40 = distinct !DIGlobalVariable(scope: null, file: !22, line: 55, type: !41, isLocal: true, isDefinition: true)
!41 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 40, elements: !42)
!42 = !{!43}
!43 = !DISubrange(count: 5)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(scope: null, file: !22, line: 60, type: !23, isLocal: true, isDefinition: true)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(scope: null, file: !22, line: 67, type: !23, isLocal: true, isDefinition: true)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(scope: null, file: !22, line: 98, type: !23, isLocal: true, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "string_pool_map", scope: !2, file: !52, line: 19, type: !53, isLocal: false, isDefinition: true)
!52 = !DIFile(filename: "_build/dev/lib/honey/priv/c_boilerplates/runtime_structures.bpf.h", directory: "/home/vinicius/honey-potion/test_cases", checksumkind: CSK_MD5, checksum: "c2bd38c05cd37ff863c88000051eef3c")
!53 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !52, line: 13, size: 256, elements: !54)
!54 = !{!55, !59, !64, !67}
!55 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !53, file: !52, line: 15, baseType: !56, size: 64)
!56 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !57, size: 64)
!57 = !DICompositeType(tag: DW_TAG_array_type, baseType: !58, size: 192, elements: !37)
!58 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !53, file: !52, line: 16, baseType: !60, size: 64, offset: 64)
!60 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !61, size: 64)
!61 = !DICompositeType(tag: DW_TAG_array_type, baseType: !58, size: 32, elements: !62)
!62 = !{!63}
!63 = !DISubrange(count: 1)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !53, file: !52, line: 17, baseType: !65, size: 64, offset: 128)
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !66, size: 64)
!66 = !DICompositeType(tag: DW_TAG_array_type, baseType: !58, size: 128, elements: !32)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !53, file: !52, line: 18, baseType: !68, size: 64, offset: 192)
!68 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !69, size: 64)
!69 = !DICompositeType(tag: DW_TAG_array_type, baseType: !58, size: 16000, elements: !70)
!70 = !{!71}
!71 = !DISubrange(count: 500)
!72 = !DIGlobalVariableExpression(var: !73, expr: !DIExpression())
!73 = distinct !DIGlobalVariable(name: "string_pool_index_map", scope: !2, file: !52, line: 27, type: !74, isLocal: false, isDefinition: true)
!74 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !52, line: 21, size: 256, elements: !75)
!75 = !{!76, !77, !78, !79}
!76 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !74, file: !52, line: 23, baseType: !56, size: 64)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !74, file: !52, line: 24, baseType: !60, size: 64, offset: 64)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !74, file: !52, line: 25, baseType: !65, size: 64, offset: 128)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !74, file: !52, line: 26, baseType: !65, size: 64, offset: 192)
!80 = !DIGlobalVariableExpression(var: !81, expr: !DIExpression())
!81 = distinct !DIGlobalVariable(name: "tuple_pool_map", scope: !2, file: !52, line: 36, type: !82, isLocal: false, isDefinition: true)
!82 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !52, line: 30, size: 256, elements: !83)
!83 = !{!84, !85, !86, !87}
!84 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !82, file: !52, line: 32, baseType: !56, size: 64)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !82, file: !52, line: 33, baseType: !60, size: 64, offset: 64)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !82, file: !52, line: 34, baseType: !65, size: 64, offset: 128)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !82, file: !52, line: 35, baseType: !88, size: 64, offset: 192)
!88 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !89, size: 64)
!89 = !DICompositeType(tag: DW_TAG_array_type, baseType: !58, size: 64000, elements: !90)
!90 = !{!91}
!91 = !DISubrange(count: 2000)
!92 = !DIGlobalVariableExpression(var: !93, expr: !DIExpression())
!93 = distinct !DIGlobalVariable(name: "tuple_pool_index_map", scope: !2, file: !52, line: 44, type: !94, isLocal: false, isDefinition: true)
!94 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !52, line: 38, size: 256, elements: !95)
!95 = !{!96, !97, !98, !99}
!96 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !94, file: !52, line: 40, baseType: !56, size: 64)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !94, file: !52, line: 41, baseType: !60, size: 64, offset: 64)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !94, file: !52, line: 42, baseType: !65, size: 64, offset: 128)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !94, file: !52, line: 43, baseType: !65, size: 64, offset: 192)
!100 = !DIGlobalVariableExpression(var: !101, expr: !DIExpression())
!101 = distinct !DIGlobalVariable(name: "heap_map", scope: !2, file: !52, line: 53, type: !102, isLocal: false, isDefinition: true)
!102 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !52, line: 47, size: 256, elements: !103)
!103 = !{!104, !105, !106, !107}
!104 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !102, file: !52, line: 49, baseType: !56, size: 64)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !102, file: !52, line: 50, baseType: !60, size: 64, offset: 64)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !102, file: !52, line: 51, baseType: !65, size: 64, offset: 128)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !102, file: !52, line: 52, baseType: !108, size: 64, offset: 192)
!108 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !109, size: 64)
!109 = !DICompositeType(tag: DW_TAG_array_type, baseType: !58, size: 76800, elements: !110)
!110 = !{!111}
!111 = !DISubrange(count: 2400)
!112 = !DIGlobalVariableExpression(var: !113, expr: !DIExpression())
!113 = distinct !DIGlobalVariable(name: "heap_index_map", scope: !2, file: !52, line: 61, type: !114, isLocal: false, isDefinition: true)
!114 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !52, line: 55, size: 256, elements: !115)
!115 = !{!116, !117, !118, !119}
!116 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !114, file: !52, line: 57, baseType: !56, size: 64)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !114, file: !52, line: 58, baseType: !60, size: 64, offset: 64)
!118 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !114, file: !52, line: 59, baseType: !65, size: 64, offset: 128)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !114, file: !52, line: 60, baseType: !65, size: 64, offset: 192)
!120 = !DIGlobalVariableExpression(var: !121, expr: !DIExpression())
!121 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !122, line: 50, type: !123, isLocal: true, isDefinition: true)
!122 = !DIFile(filename: "/usr/include/bpf/bpf_helper_defs.h", directory: "", checksumkind: CSK_MD5, checksum: "eadf4a8bcf7ac4e7bd6d2cb666452242")
!123 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !124, size: 64)
!124 = !DISubroutineType(types: !125)
!125 = !{!126, !126, !127}
!126 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!127 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !128, size: 64)
!128 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!129 = !DIGlobalVariableExpression(var: !130, expr: !DIExpression())
!130 = distinct !DIGlobalVariable(name: "bpf_get_current_pid_tgid", scope: !2, file: !122, line: 361, type: !131, isLocal: true, isDefinition: true)
!131 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !132, size: 64)
!132 = !DISubroutineType(types: !133)
!133 = !{!134}
!134 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !135, line: 31, baseType: !136)
!135 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!136 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!137 = !DIGlobalVariableExpression(var: !138, expr: !DIExpression())
!138 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !122, line: 171, type: !139, isLocal: true, isDefinition: true)
!139 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !140, size: 64)
!140 = !DISubroutineType(types: !141)
!141 = !{!142, !143, !145, null}
!142 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!143 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !144, size: 64)
!144 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !24)
!145 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !135, line: 27, baseType: !7)
!146 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 104, elements: !147)
!147 = !{!148}
!148 = !DISubrange(count: 13)
!149 = !{i32 7, !"Dwarf Version", i32 5}
!150 = !{i32 2, !"Debug Info Version", i32 3}
!151 = !{i32 1, !"wchar_size", i32 4}
!152 = !{i32 7, !"frame-pointer", i32 2}
!153 = !{!"Homebrew clang version 15.0.7"}
!154 = distinct !DISubprogram(name: "main_func", scope: !22, file: !22, line: 29, type: !155, scopeLine: 29, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !166)
!155 = !DISubroutineType(types: !156)
!156 = !{!58, !157}
!157 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !158, size: 64)
!158 = !DIDerivedType(tag: DW_TAG_typedef, name: "syscalls_enter_kill_args", file: !22, line: 22, baseType: !159)
!159 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "syscalls_enter_kill_args", file: !22, line: 11, size: 256, elements: !160)
!160 = !{!161, !163, !164, !165}
!161 = !DIDerivedType(tag: DW_TAG_member, name: "pad", scope: !159, file: !22, line: 17, baseType: !162, size: 64)
!162 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!163 = !DIDerivedType(tag: DW_TAG_member, name: "syscall_nr", scope: !159, file: !22, line: 19, baseType: !142, size: 64, offset: 64)
!164 = !DIDerivedType(tag: DW_TAG_member, name: "pid", scope: !159, file: !22, line: 20, baseType: !142, size: 64, offset: 128)
!165 = !DIDerivedType(tag: DW_TAG_member, name: "sig", scope: !159, file: !22, line: 21, baseType: !142, size: 64, offset: 192)
!166 = !{!167, !168, !176, !177, !178, !218, !219, !222, !224, !229, !230, !233, !234, !235, !240, !241, !246}
!167 = !DILocalVariable(name: "ctx_arg", arg: 1, scope: !154, file: !22, line: 29, type: !157)
!168 = !DILocalVariable(name: "str_param1", scope: !154, file: !22, line: 31, type: !169)
!169 = !DIDerivedType(tag: DW_TAG_typedef, name: "StrFormatSpec", file: !6, line: 105, baseType: !170)
!170 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "StrFormatSpec", file: !6, line: 102, size: 16, elements: !171)
!171 = !{!172}
!172 = !DIDerivedType(tag: DW_TAG_member, name: "spec", scope: !170, file: !6, line: 104, baseType: !173, size: 16)
!173 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 16, elements: !174)
!174 = !{!175}
!175 = !DISubrange(count: 2)
!176 = !DILocalVariable(name: "str_param2", scope: !154, file: !22, line: 32, type: !169)
!177 = !DILocalVariable(name: "str_param3", scope: !154, file: !22, line: 33, type: !169)
!178 = !DILocalVariable(name: "op_result", scope: !154, file: !22, line: 35, type: !179)
!179 = !DIDerivedType(tag: DW_TAG_typedef, name: "OpResult", file: !6, line: 100, baseType: !180)
!180 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "OpResult", file: !6, line: 95, size: 1472, elements: !181)
!181 = !{!182, !216, !217}
!182 = !DIDerivedType(tag: DW_TAG_member, name: "result_var", scope: !180, file: !6, line: 97, baseType: !183, size: 192)
!183 = !DIDerivedType(tag: DW_TAG_typedef, name: "Generic", file: !6, line: 93, baseType: !184)
!184 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Generic", file: !6, line: 89, size: 192, elements: !185)
!185 = !{!186, !188}
!186 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !184, file: !6, line: 91, baseType: !187, size: 32)
!187 = !DIDerivedType(tag: DW_TAG_typedef, name: "Type", file: !6, line: 52, baseType: !5)
!188 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !184, file: !6, line: 92, baseType: !189, size: 128, offset: 64)
!189 = !DIDerivedType(tag: DW_TAG_typedef, name: "ElixirValue", file: !6, line: 87, baseType: !190)
!190 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "ElixirValue", file: !6, line: 79, size: 128, elements: !191)
!191 = !{!192, !193, !194, !196, !202, !208}
!192 = !DIDerivedType(tag: DW_TAG_member, name: "integer", scope: !190, file: !6, line: 81, baseType: !142, size: 64)
!193 = !DIDerivedType(tag: DW_TAG_member, name: "u_integer", scope: !190, file: !6, line: 82, baseType: !7, size: 32)
!194 = !DIDerivedType(tag: DW_TAG_member, name: "double_precision", scope: !190, file: !6, line: 83, baseType: !195, size: 64)
!195 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!196 = !DIDerivedType(tag: DW_TAG_member, name: "tuple", scope: !190, file: !6, line: 84, baseType: !197, size: 64)
!197 = !DIDerivedType(tag: DW_TAG_typedef, name: "Tuple", file: !6, line: 58, baseType: !198)
!198 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Tuple", file: !6, line: 54, size: 64, elements: !199)
!199 = !{!200, !201}
!200 = !DIDerivedType(tag: DW_TAG_member, name: "start", scope: !198, file: !6, line: 56, baseType: !58, size: 32)
!201 = !DIDerivedType(tag: DW_TAG_member, name: "end", scope: !198, file: !6, line: 57, baseType: !58, size: 32, offset: 32)
!202 = !DIDerivedType(tag: DW_TAG_member, name: "string", scope: !190, file: !6, line: 85, baseType: !203, size: 64)
!203 = !DIDerivedType(tag: DW_TAG_typedef, name: "String", file: !6, line: 64, baseType: !204)
!204 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "String", file: !6, line: 60, size: 64, elements: !205)
!205 = !{!206, !207}
!206 = !DIDerivedType(tag: DW_TAG_member, name: "start", scope: !204, file: !6, line: 62, baseType: !58, size: 32)
!207 = !DIDerivedType(tag: DW_TAG_member, name: "end", scope: !204, file: !6, line: 63, baseType: !58, size: 32, offset: 32)
!208 = !DIDerivedType(tag: DW_TAG_member, name: "syscalls_enter_kill_args", scope: !190, file: !6, line: 86, baseType: !209, size: 128)
!209 = !DIDerivedType(tag: DW_TAG_typedef, name: "struct_Syscalls_enter_kill_args", file: !6, line: 77, baseType: !210)
!210 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "struct_Syscalls_enter_kill_args", file: !6, line: 71, size: 128, elements: !211)
!211 = !{!212, !213, !214, !215}
!212 = !DIDerivedType(tag: DW_TAG_member, name: "pos_pad", scope: !210, file: !6, line: 73, baseType: !7, size: 32)
!213 = !DIDerivedType(tag: DW_TAG_member, name: "pos_syscall_nr", scope: !210, file: !6, line: 74, baseType: !7, size: 32, offset: 32)
!214 = !DIDerivedType(tag: DW_TAG_member, name: "pos_pid", scope: !210, file: !6, line: 75, baseType: !7, size: 32, offset: 64)
!215 = !DIDerivedType(tag: DW_TAG_member, name: "pos_sig", scope: !210, file: !6, line: 76, baseType: !7, size: 32, offset: 96)
!216 = !DIDerivedType(tag: DW_TAG_member, name: "exception", scope: !180, file: !6, line: 98, baseType: !58, size: 32, offset: 192)
!217 = !DIDerivedType(tag: DW_TAG_member, name: "exception_msg", scope: !180, file: !6, line: 99, baseType: !23, size: 1200, offset: 224)
!218 = !DILocalVariable(name: "zero", scope: !154, file: !22, line: 37, type: !58)
!219 = !DILocalVariable(name: "string_pool", scope: !154, file: !22, line: 38, type: !220)
!220 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !221, size: 64)
!221 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 4000, elements: !70)
!222 = !DILocalVariable(name: "string_pool_index", scope: !154, file: !22, line: 45, type: !223)
!223 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!224 = !DILocalVariable(name: "heap", scope: !154, file: !22, line: 57, type: !225)
!225 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !226, size: 64)
!226 = !DICompositeType(tag: DW_TAG_array_type, baseType: !183, size: 19200, elements: !227)
!227 = !{!228}
!228 = !DISubrange(count: 100)
!229 = !DILocalVariable(name: "heap_index", scope: !154, file: !22, line: 64, type: !223)
!230 = !DILocalVariable(name: "tuple_pool", scope: !154, file: !22, line: 72, type: !231)
!231 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !232, size: 64)
!232 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 16000, elements: !70)
!233 = !DILocalVariable(name: "tuple_pool_index", scope: !154, file: !22, line: 79, type: !223)
!234 = !DILocalVariable(name: "helper_var_962", scope: !154, file: !22, line: 90, type: !183)
!235 = !DILocalVariable(name: "____fmt", scope: !236, file: !22, line: 92, type: !237)
!236 = distinct !DILexicalBlock(scope: !154, file: !22, line: 92, column: 1)
!237 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 128, elements: !238)
!238 = !{!239}
!239 = !DISubrange(count: 16)
!240 = !DILocalVariable(name: "helper_var_1026", scope: !154, file: !22, line: 93, type: !183)
!241 = !DILocalVariable(name: "____fmt", scope: !242, file: !22, line: 104, type: !243)
!242 = distinct !DILexicalBlock(scope: !154, file: !22, line: 104, column: 3)
!243 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 56, elements: !244)
!244 = !{!245}
!245 = !DISubrange(count: 7)
!246 = !DILabel(scope: !154, name: "CATCH", file: !22, line: 103)
!247 = !DILocation(line: 31, column: 15, scope: !154)
!248 = !DILocation(line: 32, column: 15, scope: !154)
!249 = !DILocation(line: 33, column: 15, scope: !154)
!250 = !DILocation(line: 0, scope: !154)
!251 = !DILocation(line: 35, column: 1, scope: !154)
!252 = !DILocation(line: 35, column: 10, scope: !154)
!253 = !DILocation(line: 37, column: 1, scope: !154)
!254 = !DILocation(line: 37, column: 5, scope: !154)
!255 = !{!256, !256, i64 0}
!256 = !{!"int", !257, i64 0}
!257 = !{!"omnipotent char", !258, i64 0}
!258 = !{!"Simple C/C++ TBAA"}
!259 = !DILocation(line: 38, column: 40, scope: !154)
!260 = !DILocation(line: 39, column: 6, scope: !261)
!261 = distinct !DILexicalBlock(scope: !154, file: !22, line: 39, column: 5)
!262 = !DILocation(line: 39, column: 5, scope: !154)
!263 = !DILocation(line: 41, column: 25, scope: !264)
!264 = distinct !DILexicalBlock(scope: !261, file: !22, line: 40, column: 1)
!265 = !DILocation(line: 41, column: 15, scope: !264)
!266 = !{i64 0, i64 4, !255, i64 4, i64 150, !267}
!267 = !{!257, !257, i64 0}
!268 = !{i64 0, i64 150, !267}
!269 = !DILocation(line: 42, column: 3, scope: !264)
!270 = !DILocation(line: 45, column: 31, scope: !154)
!271 = !DILocation(line: 46, column: 6, scope: !272)
!272 = distinct !DILexicalBlock(scope: !154, file: !22, line: 46, column: 5)
!273 = !DILocation(line: 46, column: 5, scope: !154)
!274 = !DILocation(line: 48, column: 25, scope: !275)
!275 = distinct !DILexicalBlock(scope: !272, file: !22, line: 47, column: 1)
!276 = !DILocation(line: 48, column: 15, scope: !275)
!277 = !DILocation(line: 49, column: 3, scope: !275)
!278 = !DILocation(line: 51, column: 20, scope: !154)
!279 = !DILocation(line: 53, column: 1, scope: !154)
!280 = !DILocation(line: 54, column: 31, scope: !154)
!281 = !DILocation(line: 54, column: 1, scope: !154)
!282 = !DILocation(line: 55, column: 35, scope: !154)
!283 = !DILocation(line: 55, column: 1, scope: !154)
!284 = !DILocation(line: 57, column: 29, scope: !154)
!285 = !DILocation(line: 58, column: 6, scope: !286)
!286 = distinct !DILexicalBlock(scope: !154, file: !22, line: 58, column: 5)
!287 = !DILocation(line: 58, column: 5, scope: !154)
!288 = !DILocation(line: 60, column: 25, scope: !289)
!289 = distinct !DILexicalBlock(scope: !286, file: !22, line: 59, column: 1)
!290 = !DILocation(line: 60, column: 15, scope: !289)
!291 = !DILocation(line: 61, column: 3, scope: !289)
!292 = !DILocation(line: 64, column: 24, scope: !154)
!293 = !DILocation(line: 65, column: 6, scope: !294)
!294 = distinct !DILexicalBlock(scope: !154, file: !22, line: 65, column: 5)
!295 = !DILocation(line: 65, column: 5, scope: !154)
!296 = !DILocation(line: 67, column: 25, scope: !297)
!297 = distinct !DILexicalBlock(scope: !294, file: !22, line: 66, column: 1)
!298 = !DILocation(line: 67, column: 15, scope: !297)
!299 = !DILocation(line: 68, column: 3, scope: !297)
!300 = !DILocation(line: 70, column: 13, scope: !154)
!301 = !DILocation(line: 72, column: 43, scope: !154)
!302 = !DILocation(line: 73, column: 6, scope: !303)
!303 = distinct !DILexicalBlock(scope: !154, file: !22, line: 73, column: 5)
!304 = !DILocation(line: 73, column: 5, scope: !154)
!305 = !DILocation(line: 75, column: 25, scope: !306)
!306 = distinct !DILexicalBlock(scope: !303, file: !22, line: 74, column: 1)
!307 = !DILocation(line: 75, column: 15, scope: !306)
!308 = !DILocation(line: 76, column: 3, scope: !306)
!309 = !DILocation(line: 79, column: 30, scope: !154)
!310 = !DILocation(line: 80, column: 6, scope: !311)
!311 = distinct !DILexicalBlock(scope: !154, file: !22, line: 80, column: 5)
!312 = !DILocation(line: 80, column: 5, scope: !154)
!313 = !DILocation(line: 82, column: 25, scope: !314)
!314 = distinct !DILexicalBlock(scope: !311, file: !22, line: 81, column: 1)
!315 = !DILocation(line: 82, column: 15, scope: !314)
!316 = !DILocation(line: 83, column: 3, scope: !314)
!317 = !DILocation(line: 85, column: 19, scope: !154)
!318 = !DILocation(line: 90, column: 61, scope: !154)
!319 = !DILocation(line: 92, column: 1, scope: !236)
!320 = !DILocation(line: 92, column: 1, scope: !154)
!321 = !DILocation(line: 101, column: 1, scope: !154)
!322 = !DILocation(line: 103, column: 1, scope: !154)
!323 = !DILocation(line: 104, column: 3, scope: !242)
!324 = !DILocation(line: 104, column: 3, scope: !154)
!325 = !DILocation(line: 105, column: 3, scope: !154)
!326 = !DILocation(line: 107, column: 1, scope: !154)
