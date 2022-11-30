; ModuleID = 'Test2.bpf.c'
source_filename = "Test2.bpf.c"
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
@string_pool_map = dso_local global %struct.anon zeroinitializer, section ".maps", align 8, !dbg !119
@.str = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4
@string_pool_index_map = dso_local global %struct.anon.0 zeroinitializer, section ".maps", align 8, !dbg !141
@.str.1 = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool index, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4
@.str.2 = private unnamed_addr constant [4 x i8] c"nil\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"false\00", align 1
@heap_map = dso_local global %struct.anon.1 zeroinitializer, section ".maps", align 8, !dbg !149
@.str.5 = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access heap map, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4
@heap_index_map = dso_local global %struct.anon.2 zeroinitializer, section ".maps", align 8, !dbg !161
@.str.6 = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access heap map index, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4
@main_func.____fmt = internal constant [15 x i8] c"Goodbye world!\00", align 1, !dbg !19
@main_func.____fmt.8 = internal constant [7 x i8] c"** %s\0A\00", align 1, !dbg !114
@llvm.compiler.used = appending global [6 x i8*] [i8* getelementptr inbounds ([13 x i8], [13 x i8]* @LICENSE, i32 0, i32 0), i8* bitcast (%struct.anon.2* @heap_index_map to i8*), i8* bitcast (%struct.anon.1* @heap_map to i8*), i8* bitcast (i32 (%struct.syscalls_enter_kill_args*)* @main_func to i8*), i8* bitcast (%struct.anon.0* @string_pool_index_map to i8*), i8* bitcast (%struct.anon* @string_pool_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @main_func(%struct.syscalls_enter_kill_args* nocapture noundef readonly %0) #0 section "tracepoint/syscalls/sys_enter_kill" !dbg !21 {
  call void @llvm.dbg.declare(metadata [2 x i8]* undef, metadata !36, metadata !DIExpression()), !dbg !194
  call void @llvm.dbg.declare(metadata [2 x i8]* undef, metadata !45, metadata !DIExpression()), !dbg !195
  call void @llvm.dbg.declare(metadata [2 x i8]* undef, metadata !46, metadata !DIExpression()), !dbg !196
  %2 = alloca %struct.OpResult, align 8
  %3 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.syscalls_enter_kill_args* %0, metadata !35, metadata !DIExpression()), !dbg !197
  %4 = bitcast %struct.OpResult* %2 to i8*, !dbg !198
  call void @llvm.lifetime.start.p0i8(i64 184, i8* nonnull %4) #6, !dbg !198
  call void @llvm.dbg.declare(metadata %struct.OpResult* %2, metadata !47, metadata !DIExpression()), !dbg !199
  %5 = bitcast i32* %3 to i8*, !dbg !200
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %5) #6, !dbg !200
  call void @llvm.dbg.value(metadata i32 0, metadata !91, metadata !DIExpression()), !dbg !197
  store i32 0, i32* %3, align 4, !dbg !201, !tbaa !202
  call void @llvm.dbg.value(metadata i32* %3, metadata !91, metadata !DIExpression(DW_OP_deref)), !dbg !197
  %6 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon* @string_pool_map to i8*), i8* noundef nonnull %5) #6, !dbg !206
  call void @llvm.dbg.value(metadata i8* %6, metadata !92, metadata !DIExpression()), !dbg !197
  %7 = icmp eq i8* %6, null, !dbg !207
  br i1 %7, label %8, label %12, !dbg !209

8:                                                ; preds = %1
  %9 = bitcast %struct.OpResult* %2 to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(24) %9, i8 0, i64 24, i1 false), !dbg !210
  %10 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 1, !dbg !212
  store i32 1, i32* %10, align 8, !dbg !212, !tbaa.struct !213
  %11 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 2, i64 0, !dbg !212
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(150) %11, i8* noundef nonnull align 4 dereferenceable(150) getelementptr inbounds ([150 x i8], [150 x i8]* @.str, i64 0, i64 0), i64 150, i1 false), !dbg !212, !tbaa.struct !215
  br label %75, !dbg !216

12:                                               ; preds = %1
  call void @llvm.dbg.value(metadata i32* %3, metadata !91, metadata !DIExpression(DW_OP_deref)), !dbg !197
  %13 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon.0* @string_pool_index_map to i8*), i8* noundef nonnull %5) #6, !dbg !217
  call void @llvm.dbg.value(metadata i8* %13, metadata !97, metadata !DIExpression()), !dbg !197
  %14 = icmp eq i8* %13, null, !dbg !218
  br i1 %14, label %15, label %19, !dbg !220

15:                                               ; preds = %12
  %16 = bitcast %struct.OpResult* %2 to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(24) %16, i8 0, i64 24, i1 false), !dbg !221
  %17 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 1, !dbg !223
  store i32 1, i32* %17, align 8, !dbg !223, !tbaa.struct !213
  %18 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 2, i64 0, !dbg !223
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(150) %18, i8* noundef nonnull align 4 dereferenceable(150) getelementptr inbounds ([150 x i8], [150 x i8]* @.str.1, i64 0, i64 0), i64 150, i1 false), !dbg !223, !tbaa.struct !215
  br label %75, !dbg !224

19:                                               ; preds = %12
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(3) %6, i8* noundef nonnull align 1 dereferenceable(3) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i64 0, i64 0), i64 3, i1 false), !dbg !225
  %20 = getelementptr inbounds i8, i8* %6, i64 3, !dbg !226
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(5) %20, i8* noundef nonnull align 1 dereferenceable(5) getelementptr inbounds ([6 x i8], [6 x i8]* @.str.3, i64 0, i64 0), i64 5, i1 false), !dbg !227
  %21 = getelementptr inbounds i8, i8* %6, i64 8, !dbg !228
  %22 = bitcast i8* %21 to i32*, !dbg !229
  store i32 1702195828, i32* %22, align 1, !dbg !229
  call void @llvm.dbg.value(metadata i32* %3, metadata !91, metadata !DIExpression(DW_OP_deref)), !dbg !197
  %23 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon.1* @heap_map to i8*), i8* noundef nonnull %5) #6, !dbg !230
  %24 = bitcast i8* %23 to [100 x %struct.Generic]*, !dbg !230
  call void @llvm.dbg.value(metadata [100 x %struct.Generic]* %24, metadata !99, metadata !DIExpression()), !dbg !197
  %25 = icmp eq i8* %23, null, !dbg !231
  br i1 %25, label %26, label %30, !dbg !233

26:                                               ; preds = %19
  %27 = bitcast %struct.OpResult* %2 to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(24) %27, i8 0, i64 24, i1 false), !dbg !234
  %28 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 1, !dbg !236
  store i32 1, i32* %28, align 8, !dbg !236, !tbaa.struct !213
  %29 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 2, i64 0, !dbg !236
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(150) %29, i8* noundef nonnull align 4 dereferenceable(150) getelementptr inbounds ([150 x i8], [150 x i8]* @.str.5, i64 0, i64 0), i64 150, i1 false), !dbg !236, !tbaa.struct !215
  br label %75, !dbg !237

30:                                               ; preds = %19
  call void @llvm.dbg.value(metadata i32* %3, metadata !91, metadata !DIExpression(DW_OP_deref)), !dbg !197
  %31 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon.2* @heap_index_map to i8*), i8* noundef nonnull %5) #6, !dbg !238
  %32 = bitcast i8* %31 to i32*, !dbg !238
  call void @llvm.dbg.value(metadata i32* %32, metadata !104, metadata !DIExpression()), !dbg !197
  %33 = icmp eq i8* %31, null, !dbg !239
  br i1 %33, label %34, label %38, !dbg !241

34:                                               ; preds = %30
  %35 = bitcast %struct.OpResult* %2 to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(24) %35, i8 0, i64 24, i1 false), !dbg !242
  %36 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 1, !dbg !244
  store i32 1, i32* %36, align 8, !dbg !244, !tbaa.struct !213
  %37 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 2, i64 0, !dbg !244
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(150) %37, i8* noundef nonnull align 4 dereferenceable(150) getelementptr inbounds ([150 x i8], [150 x i8]* @.str.6, i64 0, i64 0), i64 150, i1 false), !dbg !244, !tbaa.struct !215
  br label %75, !dbg !245

38:                                               ; preds = %30
  call void @llvm.dbg.value(metadata i32 9, metadata !105, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !197
  %39 = load i32, i32* %32, align 4, !dbg !246, !tbaa !202
  %40 = add i32 %39, 1, !dbg !246
  call void @llvm.dbg.value(metadata i32 %39, metadata !105, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 32)), !dbg !197
  %41 = add i32 %39, 2, !dbg !247
  call void @llvm.dbg.value(metadata i32 %40, metadata !105, metadata !DIExpression(DW_OP_LLVM_fragment, 96, 32)), !dbg !197
  %42 = add i32 %39, 3, !dbg !248
  call void @llvm.dbg.value(metadata i32 %41, metadata !105, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 32)), !dbg !197
  %43 = add i32 %39, 4, !dbg !249
  store i32 %43, i32* %32, align 4, !dbg !249, !tbaa !202
  call void @llvm.dbg.value(metadata i32 %42, metadata !105, metadata !DIExpression(DW_OP_LLVM_fragment, 160, 32)), !dbg !197
  call void @llvm.dbg.value(metadata i32 %42, metadata !106, metadata !DIExpression()), !dbg !197
  %44 = icmp ult i32 %40, 100, !dbg !250
  br i1 %44, label %45, label %53, !dbg !252

45:                                               ; preds = %38
  %46 = zext i32 %40 to i64, !dbg !253
  %47 = getelementptr inbounds %struct.syscalls_enter_kill_args, %struct.syscalls_enter_kill_args* %0, i64 0, i32 1, !dbg !255
  %48 = load i64, i64* %47, align 8, !dbg !255, !tbaa !256
  %49 = trunc i64 %48 to i32, !dbg !260
  %50 = getelementptr inbounds [100 x %struct.Generic], [100 x %struct.Generic]* %24, i64 0, i64 %46, i32 0, !dbg !261
  store i32 2, i32* %50, align 8, !dbg !261, !tbaa.struct !262
  %51 = getelementptr inbounds [100 x %struct.Generic], [100 x %struct.Generic]* %24, i64 0, i64 %46, i32 1, !dbg !261
  %52 = bitcast %union.ElixirValue* %51 to i32*, !dbg !261
  store i32 %49, i32* %52, align 8, !dbg !261, !tbaa.struct !265
  br label %53, !dbg !266

53:                                               ; preds = %45, %38
  %54 = icmp ult i32 %41, 100, !dbg !267
  br i1 %54, label %55, label %63, !dbg !269

55:                                               ; preds = %53
  %56 = zext i32 %41 to i64, !dbg !270
  %57 = getelementptr inbounds %struct.syscalls_enter_kill_args, %struct.syscalls_enter_kill_args* %0, i64 0, i32 2, !dbg !272
  %58 = load i64, i64* %57, align 8, !dbg !272, !tbaa !273
  %59 = trunc i64 %58 to i32, !dbg !274
  %60 = getelementptr inbounds [100 x %struct.Generic], [100 x %struct.Generic]* %24, i64 0, i64 %56, i32 0, !dbg !275
  store i32 2, i32* %60, align 8, !dbg !275, !tbaa.struct !262
  %61 = getelementptr inbounds [100 x %struct.Generic], [100 x %struct.Generic]* %24, i64 0, i64 %56, i32 1, !dbg !275
  %62 = bitcast %union.ElixirValue* %61 to i32*, !dbg !275
  store i32 %59, i32* %62, align 8, !dbg !275, !tbaa.struct !265
  br label %63, !dbg !276

63:                                               ; preds = %55, %53
  %64 = icmp ult i32 %42, 100, !dbg !277
  br i1 %64, label %65, label %73, !dbg !279

65:                                               ; preds = %63
  %66 = zext i32 %42 to i64, !dbg !280
  %67 = getelementptr inbounds %struct.syscalls_enter_kill_args, %struct.syscalls_enter_kill_args* %0, i64 0, i32 3, !dbg !282
  %68 = load i64, i64* %67, align 8, !dbg !282, !tbaa !283
  %69 = trunc i64 %68 to i32, !dbg !284
  %70 = getelementptr inbounds [100 x %struct.Generic], [100 x %struct.Generic]* %24, i64 0, i64 %66, i32 0, !dbg !285
  store i32 2, i32* %70, align 8, !dbg !285, !tbaa.struct !262
  %71 = getelementptr inbounds [100 x %struct.Generic], [100 x %struct.Generic]* %24, i64 0, i64 %66, i32 1, !dbg !285
  %72 = bitcast %union.ElixirValue* %71 to i32*, !dbg !285
  store i32 %69, i32* %72, align 8, !dbg !285, !tbaa.struct !265
  br label %73, !dbg !286

73:                                               ; preds = %65, %63
  call void @llvm.dbg.value(metadata i64 undef, metadata !107, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !197
  call void @llvm.dbg.value(metadata i32 0, metadata !107, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 32)), !dbg !197
  %74 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @main_func.____fmt, i64 0, i64 0), i32 noundef 15, i32 noundef 0) #6, !dbg !287
  call void @llvm.dbg.value(metadata i32 2, metadata !108, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !197
  call void @llvm.dbg.value(metadata i32 undef, metadata !108, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !197
  call void @llvm.dbg.value(metadata i32 0, metadata !108, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 32)), !dbg !197
  br label %78, !dbg !289

75:                                               ; preds = %34, %26, %15, %8
  call void @llvm.dbg.label(metadata !109), !dbg !290
  %76 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 2, i64 0, !dbg !291
  %77 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @main_func.____fmt.8, i64 0, i64 0), i32 noundef 7, i8* noundef nonnull %76) #6, !dbg !291
  br label %78, !dbg !293

78:                                               ; preds = %75, %73
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %5) #6, !dbg !294
  call void @llvm.lifetime.end.p0i8(i64 184, i8* nonnull %4) #6, !dbg !294
  ret i32 0, !dbg !294
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
!llvm.module.flags = !{!189, !190, !191, !192}
!llvm.ident = !{!193}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "LICENSE", scope: !2, file: !3, line: 164, type: !186, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !18, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "Test2.bpf.c", directory: "/media/kaelsa/1tera/Kael media/kPrograms/GitHub/honey-potion/examples/lib", checksumkind: CSK_MD5, checksum: "8f2b6dda4f024c5d8ccddc75b078a7a3")
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
!18 = !{!0, !19, !114, !119, !141, !149, !161, !169, !178}
!19 = !DIGlobalVariableExpression(var: !20, expr: !DIExpression())
!20 = distinct !DIGlobalVariable(name: "____fmt", scope: !21, file: !3, line: 616, type: !110, isLocal: true, isDefinition: true)
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
!34 = !{!35, !36, !45, !46, !47, !91, !92, !97, !99, !104, !105, !106, !107, !108, !109}
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
!107 = !DILocalVariable(name: "helper_var_3", scope: !21, file: !3, line: 615, type: !52)
!108 = !DILocalVariable(name: "helper_var_35", scope: !21, file: !3, line: 617, type: !52)
!109 = !DILabel(scope: !21, name: "CATCH", file: !3, line: 627)
!110 = !DICompositeType(tag: DW_TAG_array_type, baseType: !111, size: 120, elements: !112)
!111 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !42)
!112 = !{!113}
!113 = !DISubrange(count: 15)
!114 = !DIGlobalVariableExpression(var: !115, expr: !DIExpression())
!115 = distinct !DIGlobalVariable(name: "____fmt", scope: !21, file: !3, line: 628, type: !116, isLocal: true, isDefinition: true)
!116 = !DICompositeType(tag: DW_TAG_array_type, baseType: !111, size: 56, elements: !117)
!117 = !{!118}
!118 = !DISubrange(count: 7)
!119 = !DIGlobalVariableExpression(var: !120, expr: !DIExpression())
!120 = distinct !DIGlobalVariable(name: "string_pool_map", scope: !2, file: !3, line: 136, type: !121, isLocal: false, isDefinition: true)
!121 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 130, size: 256, elements: !122)
!122 = !{!123, !128, !133, !138}
!123 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !121, file: !3, line: 132, baseType: !124, size: 64)
!124 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !125, size: 64)
!125 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 192, elements: !126)
!126 = !{!127}
!127 = !DISubrange(count: 6)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !121, file: !3, line: 133, baseType: !129, size: 64, offset: 64)
!129 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !130, size: 64)
!130 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 32, elements: !131)
!131 = !{!132}
!132 = !DISubrange(count: 1)
!133 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !121, file: !3, line: 134, baseType: !134, size: 64, offset: 128)
!134 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !135, size: 64)
!135 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 128, elements: !136)
!136 = !{!137}
!137 = !DISubrange(count: 4)
!138 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !121, file: !3, line: 135, baseType: !139, size: 64, offset: 192)
!139 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !140, size: 64)
!140 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 16000, elements: !95)
!141 = !DIGlobalVariableExpression(var: !142, expr: !DIExpression())
!142 = distinct !DIGlobalVariable(name: "string_pool_index_map", scope: !2, file: !3, line: 144, type: !143, isLocal: false, isDefinition: true)
!143 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 138, size: 256, elements: !144)
!144 = !{!145, !146, !147, !148}
!145 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !143, file: !3, line: 140, baseType: !124, size: 64)
!146 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !143, file: !3, line: 141, baseType: !129, size: 64, offset: 64)
!147 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !143, file: !3, line: 142, baseType: !134, size: 64, offset: 128)
!148 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !143, file: !3, line: 143, baseType: !134, size: 64, offset: 192)
!149 = !DIGlobalVariableExpression(var: !150, expr: !DIExpression())
!150 = distinct !DIGlobalVariable(name: "heap_map", scope: !2, file: !3, line: 153, type: !151, isLocal: false, isDefinition: true)
!151 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 147, size: 256, elements: !152)
!152 = !{!153, !154, !155, !156}
!153 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !151, file: !3, line: 149, baseType: !124, size: 64)
!154 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !151, file: !3, line: 150, baseType: !129, size: 64, offset: 64)
!155 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !151, file: !3, line: 151, baseType: !134, size: 64, offset: 128)
!156 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !151, file: !3, line: 152, baseType: !157, size: 64, offset: 192)
!157 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !158, size: 64)
!158 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 76800, elements: !159)
!159 = !{!160}
!160 = !DISubrange(count: 2400)
!161 = !DIGlobalVariableExpression(var: !162, expr: !DIExpression())
!162 = distinct !DIGlobalVariable(name: "heap_index_map", scope: !2, file: !3, line: 161, type: !163, isLocal: false, isDefinition: true)
!163 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 155, size: 256, elements: !164)
!164 = !{!165, !166, !167, !168}
!165 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !163, file: !3, line: 157, baseType: !124, size: 64)
!166 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !163, file: !3, line: 158, baseType: !129, size: 64, offset: 64)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !163, file: !3, line: 159, baseType: !134, size: 64, offset: 128)
!168 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !163, file: !3, line: 160, baseType: !134, size: 64, offset: 192)
!169 = !DIGlobalVariableExpression(var: !170, expr: !DIExpression())
!170 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !171, line: 51, type: !172, isLocal: true, isDefinition: true)
!171 = !DIFile(filename: "benchmarks/libs/libbpf/src/root/usr/include/bpf/bpf_helper_defs.h", directory: "/media/kaelsa/1tera/Kael media/kPrograms/GitHub/honey-potion", checksumkind: CSK_MD5, checksum: "ad8ff3755106b533b446159c410c596d")
!172 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !173, size: 64)
!173 = !DISubroutineType(types: !174)
!174 = !{!175, !175, !176}
!175 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!176 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !177, size: 64)
!177 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!178 = !DIGlobalVariableExpression(var: !179, expr: !DIExpression())
!179 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !171, line: 172, type: !180, isLocal: true, isDefinition: true)
!180 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !181, size: 64)
!181 = !DISubroutineType(types: !182)
!182 = !{!31, !183, !184, null}
!183 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !111, size: 64)
!184 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !185, line: 27, baseType: !6)
!185 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!186 = !DICompositeType(tag: DW_TAG_array_type, baseType: !42, size: 104, elements: !187)
!187 = !{!188}
!188 = !DISubrange(count: 13)
!189 = !{i32 7, !"Dwarf Version", i32 5}
!190 = !{i32 2, !"Debug Info Version", i32 3}
!191 = !{i32 1, !"wchar_size", i32 4}
!192 = !{i32 7, !"frame-pointer", i32 2}
!193 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!194 = !DILocation(line: 554, column: 15, scope: !21)
!195 = !DILocation(line: 555, column: 15, scope: !21)
!196 = !DILocation(line: 556, column: 15, scope: !21)
!197 = !DILocation(line: 0, scope: !21)
!198 = !DILocation(line: 558, column: 1, scope: !21)
!199 = !DILocation(line: 558, column: 10, scope: !21)
!200 = !DILocation(line: 560, column: 1, scope: !21)
!201 = !DILocation(line: 560, column: 5, scope: !21)
!202 = !{!203, !203, i64 0}
!203 = !{!"int", !204, i64 0}
!204 = !{!"omnipotent char", !205, i64 0}
!205 = !{!"Simple C/C++ TBAA"}
!206 = !DILocation(line: 561, column: 40, scope: !21)
!207 = !DILocation(line: 562, column: 6, scope: !208)
!208 = distinct !DILexicalBlock(scope: !21, file: !3, line: 562, column: 5)
!209 = !DILocation(line: 562, column: 5, scope: !21)
!210 = !DILocation(line: 564, column: 25, scope: !211)
!211 = distinct !DILexicalBlock(scope: !208, file: !3, line: 563, column: 1)
!212 = !DILocation(line: 564, column: 15, scope: !211)
!213 = !{i64 0, i64 4, !202, i64 4, i64 150, !214}
!214 = !{!204, !204, i64 0}
!215 = !{i64 0, i64 150, !214}
!216 = !DILocation(line: 565, column: 3, scope: !211)
!217 = !DILocation(line: 568, column: 31, scope: !21)
!218 = !DILocation(line: 569, column: 6, scope: !219)
!219 = distinct !DILexicalBlock(scope: !21, file: !3, line: 569, column: 5)
!220 = !DILocation(line: 569, column: 5, scope: !21)
!221 = !DILocation(line: 571, column: 25, scope: !222)
!222 = distinct !DILexicalBlock(scope: !219, file: !3, line: 570, column: 1)
!223 = !DILocation(line: 571, column: 15, scope: !222)
!224 = !DILocation(line: 572, column: 3, scope: !222)
!225 = !DILocation(line: 575, column: 1, scope: !21)
!226 = !DILocation(line: 576, column: 31, scope: !21)
!227 = !DILocation(line: 576, column: 1, scope: !21)
!228 = !DILocation(line: 577, column: 35, scope: !21)
!229 = !DILocation(line: 577, column: 1, scope: !21)
!230 = !DILocation(line: 579, column: 29, scope: !21)
!231 = !DILocation(line: 580, column: 6, scope: !232)
!232 = distinct !DILexicalBlock(scope: !21, file: !3, line: 580, column: 5)
!233 = !DILocation(line: 580, column: 5, scope: !21)
!234 = !DILocation(line: 582, column: 25, scope: !235)
!235 = distinct !DILexicalBlock(scope: !232, file: !3, line: 581, column: 1)
!236 = !DILocation(line: 582, column: 15, scope: !235)
!237 = !DILocation(line: 583, column: 3, scope: !235)
!238 = !DILocation(line: 586, column: 24, scope: !21)
!239 = !DILocation(line: 587, column: 6, scope: !240)
!240 = distinct !DILexicalBlock(scope: !21, file: !3, line: 587, column: 5)
!241 = !DILocation(line: 587, column: 5, scope: !21)
!242 = !DILocation(line: 589, column: 25, scope: !243)
!243 = distinct !DILexicalBlock(scope: !240, file: !3, line: 588, column: 1)
!244 = !DILocation(line: 589, column: 15, scope: !243)
!245 = !DILocation(line: 590, column: 3, scope: !243)
!246 = !DILocation(line: 594, column: 106, scope: !21)
!247 = !DILocation(line: 594, column: 123, scope: !21)
!248 = !DILocation(line: 594, column: 140, scope: !21)
!249 = !DILocation(line: 594, column: 157, scope: !21)
!250 = !DILocation(line: 600, column: 59, scope: !251)
!251 = distinct !DILexicalBlock(scope: !21, file: !3, line: 600, column: 5)
!252 = !DILocation(line: 600, column: 5, scope: !21)
!253 = !DILocation(line: 602, column: 3, scope: !254)
!254 = distinct !DILexicalBlock(scope: !251, file: !3, line: 601, column: 1)
!255 = !DILocation(line: 602, column: 121, scope: !254)
!256 = !{!257, !259, i64 8}
!257 = !{!"syscalls_enter_kill_args", !258, i64 0, !259, i64 8, !259, i64 16, !259, i64 24}
!258 = !{!"long long", !204, i64 0}
!259 = !{!"long", !204, i64 0}
!260 = !DILocation(line: 602, column: 112, scope: !254)
!261 = !DILocation(line: 602, column: 68, scope: !254)
!262 = !{i64 0, i64 4, !214, i64 8, i64 4, !202, i64 8, i64 4, !202, i64 8, i64 8, !263, i64 8, i64 4, !202, i64 12, i64 4, !202, i64 16, i64 4, !202, i64 8, i64 4, !202, i64 12, i64 4, !202, i64 8, i64 4, !202, i64 12, i64 4, !202, i64 16, i64 4, !202, i64 20, i64 4, !202}
!263 = !{!264, !264, i64 0}
!264 = !{!"double", !204, i64 0}
!265 = !{i64 0, i64 4, !202, i64 0, i64 4, !202, i64 0, i64 8, !263, i64 0, i64 4, !202, i64 4, i64 4, !202, i64 8, i64 4, !202, i64 0, i64 4, !202, i64 4, i64 4, !202, i64 0, i64 4, !202, i64 4, i64 4, !202, i64 8, i64 4, !202, i64 12, i64 4, !202}
!266 = !DILocation(line: 603, column: 1, scope: !254)
!267 = !DILocation(line: 604, column: 52, scope: !268)
!268 = distinct !DILexicalBlock(scope: !21, file: !3, line: 604, column: 5)
!269 = !DILocation(line: 604, column: 5, scope: !21)
!270 = !DILocation(line: 606, column: 3, scope: !271)
!271 = distinct !DILexicalBlock(scope: !268, file: !3, line: 605, column: 1)
!272 = !DILocation(line: 606, column: 114, scope: !271)
!273 = !{!257, !259, i64 16}
!274 = !DILocation(line: 606, column: 105, scope: !271)
!275 = !DILocation(line: 606, column: 61, scope: !271)
!276 = !DILocation(line: 607, column: 1, scope: !271)
!277 = !DILocation(line: 608, column: 52, scope: !278)
!278 = distinct !DILexicalBlock(scope: !21, file: !3, line: 608, column: 5)
!279 = !DILocation(line: 608, column: 5, scope: !21)
!280 = !DILocation(line: 610, column: 3, scope: !281)
!281 = distinct !DILexicalBlock(scope: !278, file: !3, line: 609, column: 1)
!282 = !DILocation(line: 610, column: 114, scope: !281)
!283 = !{!257, !259, i64 24}
!284 = !DILocation(line: 610, column: 105, scope: !281)
!285 = !DILocation(line: 610, column: 61, scope: !281)
!286 = !DILocation(line: 611, column: 1, scope: !281)
!287 = !DILocation(line: 616, column: 1, scope: !288)
!288 = distinct !DILexicalBlock(scope: !21, file: !3, line: 616, column: 1)
!289 = !DILocation(line: 625, column: 1, scope: !21)
!290 = !DILocation(line: 627, column: 1, scope: !21)
!291 = !DILocation(line: 628, column: 3, scope: !292)
!292 = distinct !DILexicalBlock(scope: !21, file: !3, line: 628, column: 3)
!293 = !DILocation(line: 629, column: 3, scope: !21)
!294 = !DILocation(line: 631, column: 1, scope: !21)
