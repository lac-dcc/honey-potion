; ModuleID = 'Test1.bpf.c'
source_filename = "Test1.bpf.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.anon = type { [6 x i32]*, [1 x i32]*, [4 x i32]*, [500 x i32]* }
%struct.anon.0 = type { [6 x i32]*, [1 x i32]*, [4 x i32]*, [4 x i32]* }
%struct.anon.1 = type { [6 x i32]*, [1 x i32]*, [4 x i32]*, [2400 x i32]* }
%struct.anon.2 = type { [6 x i32]*, [1 x i32]*, [4 x i32]*, [4 x i32]* }
%struct.syscalls_enter_kill_args = type { i64, i64, i64, i64 }
%struct.OpResult = type { %struct.Generic, i32, [150 x i8] }
%struct.Generic = type { i32, %union.ElixirValue }
%union.ElixirValue = type { double, [8 x i8] }

@LICENSE = dso_local global [13 x i8] c"Dual BSD/GPL\00", section "license", align 1, !dbg !0
@string_pool_map = dso_local global %struct.anon zeroinitializer, section ".maps", align 8, !dbg !120
@.str = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4
@string_pool_index_map = dso_local global %struct.anon.0 zeroinitializer, section ".maps", align 8, !dbg !142
@.str.1 = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool index, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4
@.str.2 = private unnamed_addr constant [4 x i8] c"nil\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"false\00", align 1
@heap_map = dso_local global %struct.anon.1 zeroinitializer, section ".maps", align 8, !dbg !150
@.str.5 = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access heap map, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4
@heap_index_map = dso_local global %struct.anon.2 zeroinitializer, section ".maps", align 8, !dbg !162
@.str.6 = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access heap map index, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4
@main_func.____fmt = internal constant [13 x i8] c"Hello world!\00", align 1, !dbg !19
@main_func.____fmt.8 = internal constant [7 x i8] c"** %s\0A\00", align 1, !dbg !115
@llvm.compiler.used = appending global [6 x i8*] [i8* getelementptr inbounds ([13 x i8], [13 x i8]* @LICENSE, i32 0, i32 0), i8* bitcast (%struct.anon.2* @heap_index_map to i8*), i8* bitcast (%struct.anon.1* @heap_map to i8*), i8* bitcast (i32 (%struct.syscalls_enter_kill_args*)* @main_func to i8*), i8* bitcast (%struct.anon.0* @string_pool_index_map to i8*), i8* bitcast (%struct.anon* @string_pool_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @main_func(%struct.syscalls_enter_kill_args* nocapture noundef readonly %0) #0 section "tracepoint/syscalls/sys_enter_kill" !dbg !21 {
  call void @llvm.dbg.declare(metadata [2 x i8]* undef, metadata !36, metadata !DIExpression()), !dbg !193
  call void @llvm.dbg.declare(metadata [2 x i8]* undef, metadata !45, metadata !DIExpression()), !dbg !194
  call void @llvm.dbg.declare(metadata [2 x i8]* undef, metadata !46, metadata !DIExpression()), !dbg !195
  %2 = alloca %struct.OpResult, align 8
  %3 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.syscalls_enter_kill_args* %0, metadata !35, metadata !DIExpression()), !dbg !196
  %4 = bitcast %struct.OpResult* %2 to i8*, !dbg !197
  call void @llvm.lifetime.start.p0i8(i64 184, i8* nonnull %4) #6, !dbg !197
  call void @llvm.dbg.declare(metadata %struct.OpResult* %2, metadata !47, metadata !DIExpression()), !dbg !198
  %5 = bitcast i32* %3 to i8*, !dbg !199
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %5) #6, !dbg !199
  call void @llvm.dbg.value(metadata i32 0, metadata !91, metadata !DIExpression()), !dbg !196
  store i32 0, i32* %3, align 4, !dbg !200, !tbaa !201
  call void @llvm.dbg.value(metadata i32* %3, metadata !91, metadata !DIExpression(DW_OP_deref)), !dbg !196
  %6 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon* @string_pool_map to i8*), i8* noundef nonnull %5) #6, !dbg !205
  call void @llvm.dbg.value(metadata i8* %6, metadata !92, metadata !DIExpression()), !dbg !196
  %7 = icmp eq i8* %6, null, !dbg !206
  br i1 %7, label %8, label %12, !dbg !208

8:                                                ; preds = %1
  %9 = bitcast %struct.OpResult* %2 to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(24) %9, i8 0, i64 24, i1 false), !dbg !209
  %10 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 1, !dbg !211
  store i32 1, i32* %10, align 8, !dbg !211, !tbaa.struct !212
  %11 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 2, i64 0, !dbg !211
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(150) %11, i8* noundef nonnull align 4 dereferenceable(150) getelementptr inbounds ([150 x i8], [150 x i8]* @.str, i64 0, i64 0), i64 150, i1 false), !dbg !211, !tbaa.struct !214
  br label %75, !dbg !215

12:                                               ; preds = %1
  call void @llvm.dbg.value(metadata i32* %3, metadata !91, metadata !DIExpression(DW_OP_deref)), !dbg !196
  %13 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon.0* @string_pool_index_map to i8*), i8* noundef nonnull %5) #6, !dbg !216
  call void @llvm.dbg.value(metadata i8* %13, metadata !97, metadata !DIExpression()), !dbg !196
  %14 = icmp eq i8* %13, null, !dbg !217
  br i1 %14, label %15, label %19, !dbg !219

15:                                               ; preds = %12
  %16 = bitcast %struct.OpResult* %2 to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(24) %16, i8 0, i64 24, i1 false), !dbg !220
  %17 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 1, !dbg !222
  store i32 1, i32* %17, align 8, !dbg !222, !tbaa.struct !212
  %18 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 2, i64 0, !dbg !222
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(150) %18, i8* noundef nonnull align 4 dereferenceable(150) getelementptr inbounds ([150 x i8], [150 x i8]* @.str.1, i64 0, i64 0), i64 150, i1 false), !dbg !222, !tbaa.struct !214
  br label %75, !dbg !223

19:                                               ; preds = %12
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(3) %6, i8* noundef nonnull align 1 dereferenceable(3) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i64 0, i64 0), i64 3, i1 false), !dbg !224
  %20 = getelementptr inbounds i8, i8* %6, i64 3, !dbg !225
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(5) %20, i8* noundef nonnull align 1 dereferenceable(5) getelementptr inbounds ([6 x i8], [6 x i8]* @.str.3, i64 0, i64 0), i64 5, i1 false), !dbg !226
  %21 = getelementptr inbounds i8, i8* %6, i64 8, !dbg !227
  %22 = bitcast i8* %21 to i32*, !dbg !228
  store i32 1702195828, i32* %22, align 1, !dbg !228
  call void @llvm.dbg.value(metadata i32* %3, metadata !91, metadata !DIExpression(DW_OP_deref)), !dbg !196
  %23 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon.1* @heap_map to i8*), i8* noundef nonnull %5) #6, !dbg !229
  %24 = bitcast i8* %23 to [100 x %struct.Generic]*, !dbg !229
  call void @llvm.dbg.value(metadata [100 x %struct.Generic]* %24, metadata !99, metadata !DIExpression()), !dbg !196
  %25 = icmp eq i8* %23, null, !dbg !230
  br i1 %25, label %26, label %30, !dbg !232

26:                                               ; preds = %19
  %27 = bitcast %struct.OpResult* %2 to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(24) %27, i8 0, i64 24, i1 false), !dbg !233
  %28 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 1, !dbg !235
  store i32 1, i32* %28, align 8, !dbg !235, !tbaa.struct !212
  %29 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 2, i64 0, !dbg !235
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(150) %29, i8* noundef nonnull align 4 dereferenceable(150) getelementptr inbounds ([150 x i8], [150 x i8]* @.str.5, i64 0, i64 0), i64 150, i1 false), !dbg !235, !tbaa.struct !214
  br label %75, !dbg !236

30:                                               ; preds = %19
  call void @llvm.dbg.value(metadata i32* %3, metadata !91, metadata !DIExpression(DW_OP_deref)), !dbg !196
  %31 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon.2* @heap_index_map to i8*), i8* noundef nonnull %5) #6, !dbg !237
  %32 = bitcast i8* %31 to i32*, !dbg !237
  call void @llvm.dbg.value(metadata i32* %32, metadata !104, metadata !DIExpression()), !dbg !196
  %33 = icmp eq i8* %31, null, !dbg !238
  br i1 %33, label %34, label %38, !dbg !240

34:                                               ; preds = %30
  %35 = bitcast %struct.OpResult* %2 to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(24) %35, i8 0, i64 24, i1 false), !dbg !241
  %36 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 1, !dbg !243
  store i32 1, i32* %36, align 8, !dbg !243, !tbaa.struct !212
  %37 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 2, i64 0, !dbg !243
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(150) %37, i8* noundef nonnull align 4 dereferenceable(150) getelementptr inbounds ([150 x i8], [150 x i8]* @.str.6, i64 0, i64 0), i64 150, i1 false), !dbg !243, !tbaa.struct !214
  br label %75, !dbg !244

38:                                               ; preds = %30
  call void @llvm.dbg.value(metadata i32 9, metadata !105, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !196
  %39 = load i32, i32* %32, align 4, !dbg !245, !tbaa !201
  %40 = add i32 %39, 1, !dbg !245
  call void @llvm.dbg.value(metadata i32 %39, metadata !105, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 32)), !dbg !196
  %41 = add i32 %39, 2, !dbg !246
  call void @llvm.dbg.value(metadata i32 %40, metadata !105, metadata !DIExpression(DW_OP_LLVM_fragment, 96, 32)), !dbg !196
  %42 = add i32 %39, 3, !dbg !247
  call void @llvm.dbg.value(metadata i32 %41, metadata !105, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 32)), !dbg !196
  %43 = add i32 %39, 4, !dbg !248
  store i32 %43, i32* %32, align 4, !dbg !248, !tbaa !201
  call void @llvm.dbg.value(metadata i32 %42, metadata !105, metadata !DIExpression(DW_OP_LLVM_fragment, 160, 32)), !dbg !196
  call void @llvm.dbg.value(metadata i32 %42, metadata !106, metadata !DIExpression()), !dbg !196
  %44 = icmp ult i32 %40, 100, !dbg !249
  br i1 %44, label %45, label %53, !dbg !251

45:                                               ; preds = %38
  %46 = zext i32 %40 to i64, !dbg !252
  %47 = getelementptr inbounds %struct.syscalls_enter_kill_args, %struct.syscalls_enter_kill_args* %0, i64 0, i32 1, !dbg !254
  %48 = load i64, i64* %47, align 8, !dbg !254, !tbaa !255
  %49 = trunc i64 %48 to i32, !dbg !259
  %50 = getelementptr inbounds [100 x %struct.Generic], [100 x %struct.Generic]* %24, i64 0, i64 %46, i32 0, !dbg !260
  store i32 2, i32* %50, align 8, !dbg !260, !tbaa.struct !261
  %51 = getelementptr inbounds [100 x %struct.Generic], [100 x %struct.Generic]* %24, i64 0, i64 %46, i32 1, !dbg !260
  %52 = bitcast %union.ElixirValue* %51 to i32*, !dbg !260
  store i32 %49, i32* %52, align 8, !dbg !260, !tbaa.struct !264
  br label %53, !dbg !265

53:                                               ; preds = %45, %38
  %54 = icmp ult i32 %41, 100, !dbg !266
  br i1 %54, label %55, label %63, !dbg !268

55:                                               ; preds = %53
  %56 = zext i32 %41 to i64, !dbg !269
  %57 = getelementptr inbounds %struct.syscalls_enter_kill_args, %struct.syscalls_enter_kill_args* %0, i64 0, i32 2, !dbg !271
  %58 = load i64, i64* %57, align 8, !dbg !271, !tbaa !272
  %59 = trunc i64 %58 to i32, !dbg !273
  %60 = getelementptr inbounds [100 x %struct.Generic], [100 x %struct.Generic]* %24, i64 0, i64 %56, i32 0, !dbg !274
  store i32 2, i32* %60, align 8, !dbg !274, !tbaa.struct !261
  %61 = getelementptr inbounds [100 x %struct.Generic], [100 x %struct.Generic]* %24, i64 0, i64 %56, i32 1, !dbg !274
  %62 = bitcast %union.ElixirValue* %61 to i32*, !dbg !274
  store i32 %59, i32* %62, align 8, !dbg !274, !tbaa.struct !264
  br label %63, !dbg !275

63:                                               ; preds = %55, %53
  %64 = icmp ult i32 %42, 100, !dbg !276
  br i1 %64, label %65, label %73, !dbg !278

65:                                               ; preds = %63
  %66 = zext i32 %42 to i64, !dbg !279
  %67 = getelementptr inbounds %struct.syscalls_enter_kill_args, %struct.syscalls_enter_kill_args* %0, i64 0, i32 3, !dbg !281
  %68 = load i64, i64* %67, align 8, !dbg !281, !tbaa !282
  %69 = trunc i64 %68 to i32, !dbg !283
  %70 = getelementptr inbounds [100 x %struct.Generic], [100 x %struct.Generic]* %24, i64 0, i64 %66, i32 0, !dbg !284
  store i32 2, i32* %70, align 8, !dbg !284, !tbaa.struct !261
  %71 = getelementptr inbounds [100 x %struct.Generic], [100 x %struct.Generic]* %24, i64 0, i64 %66, i32 1, !dbg !284
  %72 = bitcast %union.ElixirValue* %71 to i32*, !dbg !284
  store i32 %69, i32* %72, align 8, !dbg !284, !tbaa.struct !264
  br label %73, !dbg !285

73:                                               ; preds = %65, %63
  call void @llvm.dbg.value(metadata i64 undef, metadata !107, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !196
  call void @llvm.dbg.value(metadata i32 0, metadata !107, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 32)), !dbg !196
  %74 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @main_func.____fmt, i64 0, i64 0), i32 noundef 13, i32 noundef 0) #6, !dbg !286
  call void @llvm.dbg.value(metadata i32 2, metadata !109, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !196
  call void @llvm.dbg.value(metadata i32 undef, metadata !109, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !196
  call void @llvm.dbg.value(metadata i32 5, metadata !109, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 32)), !dbg !196
  br label %78, !dbg !288

75:                                               ; preds = %34, %26, %15, %8
  call void @llvm.dbg.label(metadata !110), !dbg !289
  %76 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 2, i64 0, !dbg !290
  %77 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @main_func.____fmt.8, i64 0, i64 0), i32 noundef 7, i8* noundef nonnull %76) #6, !dbg !290
  br label %78, !dbg !292

78:                                               ; preds = %75, %73
  %79 = phi i32 [ 0, %75 ], [ 5, %73 ], !dbg !196
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %5) #6, !dbg !293
  call void @llvm.lifetime.end.p0i8(i64 184, i8* nonnull %4) #6, !dbg !293
  ret i32 %79, !dbg !293
}

; Function Attrs: mustprogress nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #3

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #4

; Function Attrs: mustprogress nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #5

attributes #0 = { nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #3 = { argmemonly mustprogress nofree nounwind willreturn writeonly }
attributes #4 = { argmemonly mustprogress nofree nounwind willreturn }
attributes #5 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!188, !189, !190, !191}
!llvm.ident = !{!192}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "LICENSE", scope: !2, file: !3, line: 164, type: !187, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !18, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "Test1.bpf.c", directory: "/media/kaelsa/1tera/Kael media/kPrograms/GitHub/honey-potion/examples/lib", checksumkind: CSK_MD5, checksum: "ed7b3e445d8dd8c6a69d3bc2ed035a48")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "Type", file: !3, line: 47, baseType: !6, size: 32, elements: !7)
!6 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!7 = !{!8, !9, !10, !11, !12, !13, !14, !15, !16, !17}
!8 = !DIEnumerator(name: "INVALID_TYPE", value: 0)
!9 = !DIEnumerator(name: "PATTERN_M", value: 1)
!10 = !DIEnumerator(name: "INTEGER", value: 2)
!11 = !DIEnumerator(name: "DOUBLE", value: 3)
!12 = !DIEnumerator(name: "STRING", value: 4)
!13 = !DIEnumerator(name: "ATOM", value: 5)
!14 = !DIEnumerator(name: "TUPLE", value: 6)
!15 = !DIEnumerator(name: "LIST", value: 7)
!16 = !DIEnumerator(name: "STRUCT", value: 8)
!17 = !DIEnumerator(name: "TYPE_Syscalls_enter_kill_arg", value: 9)
!18 = !{!0, !19, !115, !120, !142, !150, !162, !170, !179}
!19 = !DIGlobalVariableExpression(var: !20, expr: !DIExpression())
!20 = distinct !DIGlobalVariable(name: "____fmt", scope: !21, file: !3, line: 618, type: !111, isLocal: true, isDefinition: true)
!21 = distinct !DISubprogram(name: "main_func", scope: !3, file: !3, line: 552, type: !22, scopeLine: 552, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !34)
!22 = !DISubroutineType(types: !23)
!23 = !{!24, !25}
!24 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!25 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 64)
!26 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "syscalls_enter_kill_args", file: !3, line: 115, size: 256, elements: !27)
!27 = !{!28, !30, !32, !33}
!28 = !DIDerivedType(tag: DW_TAG_member, name: "pad", scope: !26, file: !3, line: 121, baseType: !29, size: 64)
!29 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "syscall_nr", scope: !26, file: !3, line: 123, baseType: !31, size: 64, offset: 64)
!31 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "pid", scope: !26, file: !3, line: 124, baseType: !31, size: 64, offset: 128)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "sig", scope: !26, file: !3, line: 125, baseType: !31, size: 64, offset: 192)
!34 = !{!35, !36, !45, !46, !47, !91, !92, !97, !99, !104, !105, !106, !107, !108, !109, !110}
!35 = !DILocalVariable(name: "ctx_arg", arg: 1, scope: !21, file: !3, line: 552, type: !25)
!36 = !DILocalVariable(name: "str_param1", scope: !21, file: !3, line: 554, type: !37)
!37 = !DIDerivedType(tag: DW_TAG_typedef, name: "StrFormatSpec", file: !3, line: 113, baseType: !38)
!38 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "StrFormatSpec", file: !3, line: 110, size: 16, elements: !39)
!39 = !{!40}
!40 = !DIDerivedType(tag: DW_TAG_member, name: "spec", scope: !38, file: !3, line: 112, baseType: !41, size: 16)
!41 = !DICompositeType(tag: DW_TAG_array_type, baseType: !42, size: 16, elements: !43)
!42 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!43 = !{!44}
!44 = !DISubrange(count: 2)
!45 = !DILocalVariable(name: "str_param2", scope: !21, file: !3, line: 555, type: !37)
!46 = !DILocalVariable(name: "str_param3", scope: !21, file: !3, line: 556, type: !37)
!47 = !DILocalVariable(name: "op_result", scope: !21, file: !3, line: 558, type: !48)
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "OpResult", file: !3, line: 108, baseType: !49)
!49 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "OpResult", file: !3, line: 103, size: 1472, elements: !50)
!50 = !{!51, !86, !87}
!51 = !DIDerivedType(tag: DW_TAG_member, name: "result_var", scope: !49, file: !3, line: 105, baseType: !52, size: 192)
!52 = !DIDerivedType(tag: DW_TAG_typedef, name: "Generic", file: !3, line: 101, baseType: !53)
!53 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Generic", file: !3, line: 97, size: 192, elements: !54)
!54 = !{!55, !57}
!55 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !53, file: !3, line: 99, baseType: !56, size: 32)
!56 = !DIDerivedType(tag: DW_TAG_typedef, name: "Type", file: !3, line: 59, baseType: !5)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !53, file: !3, line: 100, baseType: !58, size: 128, offset: 64)
!58 = !DIDerivedType(tag: DW_TAG_typedef, name: "ElixirValue", file: !3, line: 95, baseType: !59)
!59 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "ElixirValue", file: !3, line: 87, size: 128, elements: !60)
!60 = !{!61, !62, !63, !65, !72, !78}
!61 = !DIDerivedType(tag: DW_TAG_member, name: "integer", scope: !59, file: !3, line: 89, baseType: !24, size: 32)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "u_integer", scope: !59, file: !3, line: 90, baseType: !6, size: 32)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "double_precision", scope: !59, file: !3, line: 91, baseType: !64, size: 64)
!64 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "tuple", scope: !59, file: !3, line: 92, baseType: !66, size: 96)
!66 = !DIDerivedType(tag: DW_TAG_typedef, name: "Tuple", file: !3, line: 66, baseType: !67)
!67 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Tuple", file: !3, line: 61, size: 96, elements: !68)
!68 = !{!69, !70, !71}
!69 = !DIDerivedType(tag: DW_TAG_member, name: "idx", scope: !67, file: !3, line: 63, baseType: !24, size: 32)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "value_idx", scope: !67, file: !3, line: 64, baseType: !24, size: 32, offset: 32)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "nextElement_idx", scope: !67, file: !3, line: 65, baseType: !24, size: 32, offset: 64)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "string", scope: !59, file: !3, line: 93, baseType: !73, size: 64)
!73 = !DIDerivedType(tag: DW_TAG_typedef, name: "String", file: !3, line: 72, baseType: !74)
!74 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "String", file: !3, line: 68, size: 64, elements: !75)
!75 = !{!76, !77}
!76 = !DIDerivedType(tag: DW_TAG_member, name: "start", scope: !74, file: !3, line: 70, baseType: !24, size: 32)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "end", scope: !74, file: !3, line: 71, baseType: !24, size: 32, offset: 32)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "syscalls_enter_kill_args", scope: !59, file: !3, line: 94, baseType: !79, size: 128)
!79 = !DIDerivedType(tag: DW_TAG_typedef, name: "struct_Syscalls_enter_kill_args", file: !3, line: 85, baseType: !80)
!80 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "struct_Syscalls_enter_kill_args", file: !3, line: 79, size: 128, elements: !81)
!81 = !{!82, !83, !84, !85}
!82 = !DIDerivedType(tag: DW_TAG_member, name: "pos_pad", scope: !80, file: !3, line: 81, baseType: !6, size: 32)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "pos_syscall_nr", scope: !80, file: !3, line: 82, baseType: !6, size: 32, offset: 32)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "pos_pid", scope: !80, file: !3, line: 83, baseType: !6, size: 32, offset: 64)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "pos_sig", scope: !80, file: !3, line: 84, baseType: !6, size: 32, offset: 96)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "exception", scope: !49, file: !3, line: 106, baseType: !24, size: 32, offset: 192)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "exception_msg", scope: !49, file: !3, line: 107, baseType: !88, size: 1200, offset: 224)
!88 = !DICompositeType(tag: DW_TAG_array_type, baseType: !42, size: 1200, elements: !89)
!89 = !{!90}
!90 = !DISubrange(count: 150)
!91 = !DILocalVariable(name: "zero", scope: !21, file: !3, line: 560, type: !24)
!92 = !DILocalVariable(name: "string_pool", scope: !21, file: !3, line: 561, type: !93)
!93 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !94, size: 64)
!94 = !DICompositeType(tag: DW_TAG_array_type, baseType: !42, size: 4000, elements: !95)
!95 = !{!96}
!96 = !DISubrange(count: 500)
!97 = !DILocalVariable(name: "string_pool_index", scope: !21, file: !3, line: 568, type: !98)
!98 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!99 = !DILocalVariable(name: "heap", scope: !21, file: !3, line: 579, type: !100)
!100 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !101, size: 64)
!101 = !DICompositeType(tag: DW_TAG_array_type, baseType: !52, size: 19200, elements: !102)
!102 = !{!103}
!103 = !DISubrange(count: 100)
!104 = !DILocalVariable(name: "heap_index", scope: !21, file: !3, line: 586, type: !98)
!105 = !DILocalVariable(name: "ctx0nil", scope: !21, file: !3, line: 594, type: !52)
!106 = !DILocalVariable(name: "last_index", scope: !21, file: !3, line: 595, type: !6)
!107 = !DILocalVariable(name: "helper_var_67", scope: !21, file: !3, line: 617, type: !52)
!108 = !DILocalVariable(name: "helper_var_99", scope: !21, file: !3, line: 619, type: !52)
!109 = !DILocalVariable(name: "helper_var_131", scope: !21, file: !3, line: 621, type: !52)
!110 = !DILabel(scope: !21, name: "CATCH", file: !3, line: 631)
!111 = !DICompositeType(tag: DW_TAG_array_type, baseType: !112, size: 104, elements: !113)
!112 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !42)
!113 = !{!114}
!114 = !DISubrange(count: 13)
!115 = !DIGlobalVariableExpression(var: !116, expr: !DIExpression())
!116 = distinct !DIGlobalVariable(name: "____fmt", scope: !21, file: !3, line: 632, type: !117, isLocal: true, isDefinition: true)
!117 = !DICompositeType(tag: DW_TAG_array_type, baseType: !112, size: 56, elements: !118)
!118 = !{!119}
!119 = !DISubrange(count: 7)
!120 = !DIGlobalVariableExpression(var: !121, expr: !DIExpression())
!121 = distinct !DIGlobalVariable(name: "string_pool_map", scope: !2, file: !3, line: 136, type: !122, isLocal: false, isDefinition: true)
!122 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 130, size: 256, elements: !123)
!123 = !{!124, !129, !134, !139}
!124 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !122, file: !3, line: 132, baseType: !125, size: 64)
!125 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !126, size: 64)
!126 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 192, elements: !127)
!127 = !{!128}
!128 = !DISubrange(count: 6)
!129 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !122, file: !3, line: 133, baseType: !130, size: 64, offset: 64)
!130 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !131, size: 64)
!131 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 32, elements: !132)
!132 = !{!133}
!133 = !DISubrange(count: 1)
!134 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !122, file: !3, line: 134, baseType: !135, size: 64, offset: 128)
!135 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !136, size: 64)
!136 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 128, elements: !137)
!137 = !{!138}
!138 = !DISubrange(count: 4)
!139 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !122, file: !3, line: 135, baseType: !140, size: 64, offset: 192)
!140 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !141, size: 64)
!141 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 16000, elements: !95)
!142 = !DIGlobalVariableExpression(var: !143, expr: !DIExpression())
!143 = distinct !DIGlobalVariable(name: "string_pool_index_map", scope: !2, file: !3, line: 144, type: !144, isLocal: false, isDefinition: true)
!144 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 138, size: 256, elements: !145)
!145 = !{!146, !147, !148, !149}
!146 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !144, file: !3, line: 140, baseType: !125, size: 64)
!147 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !144, file: !3, line: 141, baseType: !130, size: 64, offset: 64)
!148 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !144, file: !3, line: 142, baseType: !135, size: 64, offset: 128)
!149 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !144, file: !3, line: 143, baseType: !135, size: 64, offset: 192)
!150 = !DIGlobalVariableExpression(var: !151, expr: !DIExpression())
!151 = distinct !DIGlobalVariable(name: "heap_map", scope: !2, file: !3, line: 153, type: !152, isLocal: false, isDefinition: true)
!152 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 147, size: 256, elements: !153)
!153 = !{!154, !155, !156, !157}
!154 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !152, file: !3, line: 149, baseType: !125, size: 64)
!155 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !152, file: !3, line: 150, baseType: !130, size: 64, offset: 64)
!156 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !152, file: !3, line: 151, baseType: !135, size: 64, offset: 128)
!157 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !152, file: !3, line: 152, baseType: !158, size: 64, offset: 192)
!158 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !159, size: 64)
!159 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 76800, elements: !160)
!160 = !{!161}
!161 = !DISubrange(count: 2400)
!162 = !DIGlobalVariableExpression(var: !163, expr: !DIExpression())
!163 = distinct !DIGlobalVariable(name: "heap_index_map", scope: !2, file: !3, line: 161, type: !164, isLocal: false, isDefinition: true)
!164 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 155, size: 256, elements: !165)
!165 = !{!166, !167, !168, !169}
!166 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !164, file: !3, line: 157, baseType: !125, size: 64)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !164, file: !3, line: 158, baseType: !130, size: 64, offset: 64)
!168 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !164, file: !3, line: 159, baseType: !135, size: 64, offset: 128)
!169 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !164, file: !3, line: 160, baseType: !135, size: 64, offset: 192)
!170 = !DIGlobalVariableExpression(var: !171, expr: !DIExpression())
!171 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !172, line: 51, type: !173, isLocal: true, isDefinition: true)
!172 = !DIFile(filename: "benchmarks/libs/libbpf/src/root/usr/include/bpf/bpf_helper_defs.h", directory: "/media/kaelsa/1tera/Kael media/kPrograms/GitHub/honey-potion", checksumkind: CSK_MD5, checksum: "ad8ff3755106b533b446159c410c596d")
!173 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !174, size: 64)
!174 = !DISubroutineType(types: !175)
!175 = !{!176, !176, !177}
!176 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!177 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !178, size: 64)
!178 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!179 = !DIGlobalVariableExpression(var: !180, expr: !DIExpression())
!180 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !172, line: 172, type: !181, isLocal: true, isDefinition: true)
!181 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !182, size: 64)
!182 = !DISubroutineType(types: !183)
!183 = !{!31, !184, !185, null}
!184 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !112, size: 64)
!185 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !186, line: 27, baseType: !6)
!186 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!187 = !DICompositeType(tag: DW_TAG_array_type, baseType: !42, size: 104, elements: !113)
!188 = !{i32 7, !"Dwarf Version", i32 5}
!189 = !{i32 2, !"Debug Info Version", i32 3}
!190 = !{i32 1, !"wchar_size", i32 4}
!191 = !{i32 7, !"frame-pointer", i32 2}
!192 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!193 = !DILocation(line: 554, column: 15, scope: !21)
!194 = !DILocation(line: 555, column: 15, scope: !21)
!195 = !DILocation(line: 556, column: 15, scope: !21)
!196 = !DILocation(line: 0, scope: !21)
!197 = !DILocation(line: 558, column: 1, scope: !21)
!198 = !DILocation(line: 558, column: 10, scope: !21)
!199 = !DILocation(line: 560, column: 1, scope: !21)
!200 = !DILocation(line: 560, column: 5, scope: !21)
!201 = !{!202, !202, i64 0}
!202 = !{!"int", !203, i64 0}
!203 = !{!"omnipotent char", !204, i64 0}
!204 = !{!"Simple C/C++ TBAA"}
!205 = !DILocation(line: 561, column: 40, scope: !21)
!206 = !DILocation(line: 562, column: 6, scope: !207)
!207 = distinct !DILexicalBlock(scope: !21, file: !3, line: 562, column: 5)
!208 = !DILocation(line: 562, column: 5, scope: !21)
!209 = !DILocation(line: 564, column: 25, scope: !210)
!210 = distinct !DILexicalBlock(scope: !207, file: !3, line: 563, column: 1)
!211 = !DILocation(line: 564, column: 15, scope: !210)
!212 = !{i64 0, i64 4, !201, i64 4, i64 150, !213}
!213 = !{!203, !203, i64 0}
!214 = !{i64 0, i64 150, !213}
!215 = !DILocation(line: 565, column: 3, scope: !210)
!216 = !DILocation(line: 568, column: 31, scope: !21)
!217 = !DILocation(line: 569, column: 6, scope: !218)
!218 = distinct !DILexicalBlock(scope: !21, file: !3, line: 569, column: 5)
!219 = !DILocation(line: 569, column: 5, scope: !21)
!220 = !DILocation(line: 571, column: 25, scope: !221)
!221 = distinct !DILexicalBlock(scope: !218, file: !3, line: 570, column: 1)
!222 = !DILocation(line: 571, column: 15, scope: !221)
!223 = !DILocation(line: 572, column: 3, scope: !221)
!224 = !DILocation(line: 575, column: 1, scope: !21)
!225 = !DILocation(line: 576, column: 31, scope: !21)
!226 = !DILocation(line: 576, column: 1, scope: !21)
!227 = !DILocation(line: 577, column: 35, scope: !21)
!228 = !DILocation(line: 577, column: 1, scope: !21)
!229 = !DILocation(line: 579, column: 29, scope: !21)
!230 = !DILocation(line: 580, column: 6, scope: !231)
!231 = distinct !DILexicalBlock(scope: !21, file: !3, line: 580, column: 5)
!232 = !DILocation(line: 580, column: 5, scope: !21)
!233 = !DILocation(line: 582, column: 25, scope: !234)
!234 = distinct !DILexicalBlock(scope: !231, file: !3, line: 581, column: 1)
!235 = !DILocation(line: 582, column: 15, scope: !234)
!236 = !DILocation(line: 583, column: 3, scope: !234)
!237 = !DILocation(line: 586, column: 24, scope: !21)
!238 = !DILocation(line: 587, column: 6, scope: !239)
!239 = distinct !DILexicalBlock(scope: !21, file: !3, line: 587, column: 5)
!240 = !DILocation(line: 587, column: 5, scope: !21)
!241 = !DILocation(line: 589, column: 25, scope: !242)
!242 = distinct !DILexicalBlock(scope: !239, file: !3, line: 588, column: 1)
!243 = !DILocation(line: 589, column: 15, scope: !242)
!244 = !DILocation(line: 590, column: 3, scope: !242)
!245 = !DILocation(line: 594, column: 106, scope: !21)
!246 = !DILocation(line: 594, column: 123, scope: !21)
!247 = !DILocation(line: 594, column: 140, scope: !21)
!248 = !DILocation(line: 594, column: 157, scope: !21)
!249 = !DILocation(line: 600, column: 59, scope: !250)
!250 = distinct !DILexicalBlock(scope: !21, file: !3, line: 600, column: 5)
!251 = !DILocation(line: 600, column: 5, scope: !21)
!252 = !DILocation(line: 602, column: 3, scope: !253)
!253 = distinct !DILexicalBlock(scope: !250, file: !3, line: 601, column: 1)
!254 = !DILocation(line: 602, column: 121, scope: !253)
!255 = !{!256, !258, i64 8}
!256 = !{!"syscalls_enter_kill_args", !257, i64 0, !258, i64 8, !258, i64 16, !258, i64 24}
!257 = !{!"long long", !203, i64 0}
!258 = !{!"long", !203, i64 0}
!259 = !DILocation(line: 602, column: 112, scope: !253)
!260 = !DILocation(line: 602, column: 68, scope: !253)
!261 = !{i64 0, i64 4, !213, i64 8, i64 4, !201, i64 8, i64 4, !201, i64 8, i64 8, !262, i64 8, i64 4, !201, i64 12, i64 4, !201, i64 16, i64 4, !201, i64 8, i64 4, !201, i64 12, i64 4, !201, i64 8, i64 4, !201, i64 12, i64 4, !201, i64 16, i64 4, !201, i64 20, i64 4, !201}
!262 = !{!263, !263, i64 0}
!263 = !{!"double", !203, i64 0}
!264 = !{i64 0, i64 4, !201, i64 0, i64 4, !201, i64 0, i64 8, !262, i64 0, i64 4, !201, i64 4, i64 4, !201, i64 8, i64 4, !201, i64 0, i64 4, !201, i64 4, i64 4, !201, i64 0, i64 4, !201, i64 4, i64 4, !201, i64 8, i64 4, !201, i64 12, i64 4, !201}
!265 = !DILocation(line: 603, column: 1, scope: !253)
!266 = !DILocation(line: 604, column: 52, scope: !267)
!267 = distinct !DILexicalBlock(scope: !21, file: !3, line: 604, column: 5)
!268 = !DILocation(line: 604, column: 5, scope: !21)
!269 = !DILocation(line: 606, column: 3, scope: !270)
!270 = distinct !DILexicalBlock(scope: !267, file: !3, line: 605, column: 1)
!271 = !DILocation(line: 606, column: 114, scope: !270)
!272 = !{!256, !258, i64 16}
!273 = !DILocation(line: 606, column: 105, scope: !270)
!274 = !DILocation(line: 606, column: 61, scope: !270)
!275 = !DILocation(line: 607, column: 1, scope: !270)
!276 = !DILocation(line: 608, column: 52, scope: !277)
!277 = distinct !DILexicalBlock(scope: !21, file: !3, line: 608, column: 5)
!278 = !DILocation(line: 608, column: 5, scope: !21)
!279 = !DILocation(line: 610, column: 3, scope: !280)
!280 = distinct !DILexicalBlock(scope: !277, file: !3, line: 609, column: 1)
!281 = !DILocation(line: 610, column: 114, scope: !280)
!282 = !{!256, !258, i64 24}
!283 = !DILocation(line: 610, column: 105, scope: !280)
!284 = !DILocation(line: 610, column: 61, scope: !280)
!285 = !DILocation(line: 611, column: 1, scope: !280)
!286 = !DILocation(line: 618, column: 1, scope: !287)
!287 = distinct !DILexicalBlock(scope: !21, file: !3, line: 618, column: 1)
!288 = !DILocation(line: 629, column: 1, scope: !21)
!289 = !DILocation(line: 631, column: 1, scope: !21)
!290 = !DILocation(line: 632, column: 3, scope: !291)
!291 = distinct !DILexicalBlock(scope: !21, file: !3, line: 632, column: 3)
!292 = !DILocation(line: 633, column: 3, scope: !21)
!293 = !DILocation(line: 635, column: 1, scope: !21)
