; ModuleID = 'prog.bpf.c'
source_filename = "prog.bpf.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.pkt_meta = type { %union.anon, %union.anon.0, [2 x i16], i16, i16, i16, i16, i32 }
%union.anon = type { [4 x i32] }
%union.anon.0 = type { [4 x i32] }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }

@perf_map = dso_local global %struct.bpf_map_def { i32 4, i32 4, i32 4, i32 128, i32 0, i32 0 }, section "maps", align 4, !dbg !0
@_license = dso_local global [13 x i8] c"Dual BSD/GPL\00", section "license", align 1, !dbg !52
@llvm.compiler.used = appending global [3 x i8*] [i8* getelementptr inbounds ([13 x i8], [13 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @perf_map to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @process_packet to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @process_packet(%struct.xdp_md* %0) #0 section "xdp" !dbg !78 {
  %2 = alloca %struct.pkt_meta, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !91, metadata !DIExpression()), !dbg !136
  %3 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !137
  %4 = load i32, i32* %3, align 4, !dbg !137, !tbaa !138
  %5 = zext i32 %4 to i64, !dbg !143
  %6 = inttoptr i64 %5 to i8*, !dbg !144
  call void @llvm.dbg.value(metadata i8* %6, metadata !92, metadata !DIExpression()), !dbg !136
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !145
  %8 = load i32, i32* %7, align 4, !dbg !145, !tbaa !146
  %9 = zext i32 %8 to i64, !dbg !147
  %10 = inttoptr i64 %9 to i8*, !dbg !148
  call void @llvm.dbg.value(metadata i8* %10, metadata !93, metadata !DIExpression()), !dbg !136
  call void @llvm.dbg.value(metadata i8* %10, metadata !94, metadata !DIExpression()), !dbg !136
  %11 = bitcast %struct.pkt_meta* %2 to i8*, !dbg !149
  call void @llvm.lifetime.start.p0i8(i64 48, i8* nonnull %11) #6, !dbg !149
  call void @llvm.dbg.declare(metadata %struct.pkt_meta* %2, metadata !108, metadata !DIExpression()), !dbg !150
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(48) %11, i8 0, i64 48, i1 false), !dbg !150
  call void @llvm.dbg.value(metadata i32 14, metadata !135, metadata !DIExpression()), !dbg !136
  %12 = getelementptr i8, i8* %10, i64 14, !dbg !151
  %13 = icmp ugt i8* %12, %6, !dbg !153
  br i1 %13, label %103, label %14, !dbg !154

14:                                               ; preds = %1
  %15 = inttoptr i64 %9 to %struct.ethhdr*, !dbg !155
  call void @llvm.dbg.value(metadata %struct.ethhdr* %15, metadata !94, metadata !DIExpression()), !dbg !136
  %16 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %15, i64 0, i32 2, !dbg !156
  %17 = load i16, i16* %16, align 1, !dbg !156, !tbaa !157
  %18 = tail call i16 @llvm.bswap.i16(i16 %17)
  %19 = getelementptr inbounds %struct.pkt_meta, %struct.pkt_meta* %2, i64 0, i32 3, !dbg !160
  store i16 %18, i16* %19, align 4, !dbg !161, !tbaa !162
  switch i16 %18, label %51 [
    i16 2048, label %20
    i16 -31011, label %36
  ], !dbg !164

20:                                               ; preds = %14
  call void @llvm.dbg.value(metadata i8* %10, metadata !165, metadata !DIExpression()), !dbg !193
  call void @llvm.dbg.value(metadata i64 14, metadata !172, metadata !DIExpression()), !dbg !193
  call void @llvm.dbg.value(metadata i8* %6, metadata !173, metadata !DIExpression()), !dbg !193
  call void @llvm.dbg.value(metadata %struct.pkt_meta* %2, metadata !174, metadata !DIExpression()), !dbg !193
  call void @llvm.dbg.value(metadata i8* %10, metadata !175, metadata !DIExpression(DW_OP_plus_uconst, 14, DW_OP_stack_value)), !dbg !193
  %21 = getelementptr i8, i8* %10, i64 34, !dbg !198
  %22 = icmp ugt i8* %21, %6, !dbg !200
  br i1 %22, label %103, label %23, !dbg !201

23:                                               ; preds = %20
  call void @llvm.dbg.value(metadata i8* %12, metadata !175, metadata !DIExpression()), !dbg !193
  %24 = load i8, i8* %12, align 4, !dbg !202
  %25 = and i8 %24, 15, !dbg !202
  %26 = icmp eq i8 %25, 5, !dbg !204
  br i1 %26, label %27, label %103, !dbg !205

27:                                               ; preds = %23
  %28 = getelementptr i8, i8* %10, i64 26, !dbg !206
  %29 = bitcast i8* %28 to i32*, !dbg !206
  %30 = load i32, i32* %29, align 4, !dbg !206, !tbaa !207
  %31 = getelementptr inbounds %struct.pkt_meta, %struct.pkt_meta* %2, i64 0, i32 0, i32 0, i64 0, !dbg !209
  store i32 %30, i32* %31, align 4, !dbg !210, !tbaa !211
  %32 = getelementptr i8, i8* %10, i64 30, !dbg !212
  %33 = bitcast i8* %32 to i32*, !dbg !212
  %34 = load i32, i32* %33, align 4, !dbg !212, !tbaa !213
  %35 = getelementptr inbounds %struct.pkt_meta, %struct.pkt_meta* %2, i64 0, i32 1, i32 0, i64 0, !dbg !214
  store i32 %34, i32* %35, align 4, !dbg !215, !tbaa !211
  br label %44, !dbg !216

36:                                               ; preds = %14
  call void @llvm.dbg.value(metadata i8* %10, metadata !217, metadata !DIExpression()) #6, !dbg !254
  call void @llvm.dbg.value(metadata i64 14, metadata !220, metadata !DIExpression()) #6, !dbg !254
  call void @llvm.dbg.value(metadata i8* %6, metadata !221, metadata !DIExpression()) #6, !dbg !254
  call void @llvm.dbg.value(metadata %struct.pkt_meta* %2, metadata !222, metadata !DIExpression()) #6, !dbg !254
  call void @llvm.dbg.value(metadata i8* %10, metadata !223, metadata !DIExpression(DW_OP_plus_uconst, 14, DW_OP_stack_value)) #6, !dbg !254
  %37 = getelementptr i8, i8* %10, i64 54, !dbg !259
  %38 = icmp ugt i8* %37, %6, !dbg !261
  br i1 %38, label %103, label %39, !dbg !262

39:                                               ; preds = %36
  call void @llvm.dbg.value(metadata i8* %10, metadata !223, metadata !DIExpression(DW_OP_plus_uconst, 14, DW_OP_stack_value)) #6, !dbg !254
  %40 = getelementptr i8, i8* %10, i64 22, !dbg !263
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(16) %11, i8* noundef nonnull align 4 dereferenceable(16) %40, i64 16, i1 false) #6, !dbg !264
  %41 = getelementptr inbounds %struct.pkt_meta, %struct.pkt_meta* %2, i64 0, i32 1, i32 0, i64 0, !dbg !265
  %42 = bitcast i32* %41 to i8*, !dbg !265
  %43 = getelementptr i8, i8* %10, i64 38, !dbg !266
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(16) %42, i8* noundef nonnull align 4 dereferenceable(16) %43, i64 16, i1 false) #6, !dbg !265
  br label %44, !dbg !267

44:                                               ; preds = %27, %39
  %45 = phi i64 [ 23, %27 ], [ 20, %39 ]
  %46 = phi i32 [ 34, %27 ], [ 54, %39 ]
  %47 = getelementptr i8, i8* %10, i64 %45, !dbg !268
  %48 = load i8, i8* %47, align 1, !dbg !268, !tbaa !211
  %49 = zext i8 %48 to i16, !dbg !268
  %50 = getelementptr inbounds %struct.pkt_meta, %struct.pkt_meta* %2, i64 0, i32 4, !dbg !268
  store i16 %49, i16* %50, align 2, !dbg !268, !tbaa !269
  br label %51, !dbg !270

51:                                               ; preds = %44, %14
  %52 = phi i8 [ 0, %14 ], [ %48, %44 ]
  %53 = phi i32 [ 14, %14 ], [ %46, %44 ], !dbg !136
  call void @llvm.dbg.value(metadata i32 %53, metadata !135, metadata !DIExpression()), !dbg !136
  %54 = zext i32 %53 to i64, !dbg !270
  %55 = getelementptr i8, i8* %10, i64 %54, !dbg !270
  %56 = icmp ugt i8* %55, %6, !dbg !272
  br i1 %56, label %103, label %57, !dbg !273

57:                                               ; preds = %51
  switch i8 %52, label %86 [
    i8 6, label %58
    i8 17, label %74
  ], !dbg !274

58:                                               ; preds = %57
  call void @llvm.dbg.value(metadata i8* %10, metadata !275, metadata !DIExpression()), !dbg !303
  call void @llvm.dbg.value(metadata i64 %54, metadata !278, metadata !DIExpression()), !dbg !303
  call void @llvm.dbg.value(metadata i8* %6, metadata !279, metadata !DIExpression()), !dbg !303
  call void @llvm.dbg.value(metadata %struct.pkt_meta* %2, metadata !280, metadata !DIExpression()), !dbg !303
  call void @llvm.dbg.value(metadata i8* %55, metadata !281, metadata !DIExpression()), !dbg !303
  %59 = getelementptr i8, i8* %55, i64 20, !dbg !308
  %60 = icmp ugt i8* %59, %6, !dbg !310
  br i1 %60, label %103, label %61, !dbg !311

61:                                               ; preds = %58
  call void @llvm.dbg.value(metadata i8* %55, metadata !281, metadata !DIExpression()), !dbg !303
  %62 = bitcast i8* %55 to i16*, !dbg !312
  %63 = load i16, i16* %62, align 4, !dbg !312, !tbaa !313
  %64 = getelementptr inbounds %struct.pkt_meta, %struct.pkt_meta* %2, i64 0, i32 2, i64 0, !dbg !315
  store i16 %63, i16* %64, align 4, !dbg !316, !tbaa !317
  %65 = getelementptr inbounds i8, i8* %55, i64 2, !dbg !318
  %66 = bitcast i8* %65 to i16*, !dbg !318
  %67 = load i16, i16* %66, align 2, !dbg !318, !tbaa !319
  %68 = getelementptr inbounds %struct.pkt_meta, %struct.pkt_meta* %2, i64 0, i32 2, i64 1, !dbg !320
  store i16 %67, i16* %68, align 2, !dbg !321, !tbaa !317
  %69 = getelementptr inbounds i8, i8* %55, i64 4, !dbg !322
  %70 = bitcast i8* %69 to i32*, !dbg !322
  %71 = load i32, i32* %70, align 4, !dbg !322, !tbaa !323
  %72 = getelementptr inbounds %struct.pkt_meta, %struct.pkt_meta* %2, i64 0, i32 7, !dbg !324
  store i32 %71, i32* %72, align 4, !dbg !325, !tbaa !326
  %73 = add nuw nsw i32 %53, 20, !dbg !327
  call void @llvm.dbg.value(metadata i32 %73, metadata !135, metadata !DIExpression()), !dbg !136
  br label %89, !dbg !328

74:                                               ; preds = %57
  call void @llvm.dbg.value(metadata i8* %10, metadata !329, metadata !DIExpression()), !dbg !344
  call void @llvm.dbg.value(metadata i64 %54, metadata !332, metadata !DIExpression()), !dbg !344
  call void @llvm.dbg.value(metadata i8* %6, metadata !333, metadata !DIExpression()), !dbg !344
  call void @llvm.dbg.value(metadata %struct.pkt_meta* %2, metadata !334, metadata !DIExpression()), !dbg !344
  call void @llvm.dbg.value(metadata i8* %55, metadata !335, metadata !DIExpression()), !dbg !344
  %75 = getelementptr i8, i8* %55, i64 8, !dbg !349
  %76 = icmp ugt i8* %75, %6, !dbg !351
  br i1 %76, label %103, label %77, !dbg !352

77:                                               ; preds = %74
  call void @llvm.dbg.value(metadata i8* %55, metadata !335, metadata !DIExpression()), !dbg !344
  %78 = bitcast i8* %55 to i16*, !dbg !353
  %79 = load i16, i16* %78, align 2, !dbg !353, !tbaa !354
  %80 = getelementptr inbounds %struct.pkt_meta, %struct.pkt_meta* %2, i64 0, i32 2, i64 0, !dbg !356
  store i16 %79, i16* %80, align 4, !dbg !357, !tbaa !317
  %81 = getelementptr inbounds i8, i8* %55, i64 2, !dbg !358
  %82 = bitcast i8* %81 to i16*, !dbg !358
  %83 = load i16, i16* %82, align 2, !dbg !358, !tbaa !359
  %84 = getelementptr inbounds %struct.pkt_meta, %struct.pkt_meta* %2, i64 0, i32 2, i64 1, !dbg !360
  store i16 %83, i16* %84, align 2, !dbg !361, !tbaa !317
  %85 = add nuw nsw i32 %53, 8, !dbg !362
  call void @llvm.dbg.value(metadata i32 %85, metadata !135, metadata !DIExpression()), !dbg !136
  br label %89, !dbg !363

86:                                               ; preds = %57
  %87 = getelementptr inbounds %struct.pkt_meta, %struct.pkt_meta* %2, i64 0, i32 2, i64 0, !dbg !364
  store i16 0, i16* %87, align 4, !dbg !366, !tbaa !317
  %88 = getelementptr inbounds %struct.pkt_meta, %struct.pkt_meta* %2, i64 0, i32 2, i64 1, !dbg !367
  store i16 0, i16* %88, align 2, !dbg !368, !tbaa !317
  br label %89

89:                                               ; preds = %77, %86, %61
  %90 = phi i32 [ %73, %61 ], [ %85, %77 ], [ %53, %86 ], !dbg !136
  call void @llvm.dbg.value(metadata i32 %90, metadata !135, metadata !DIExpression()), !dbg !136
  %91 = sub nsw i64 %5, %9, !dbg !369
  %92 = trunc i64 %91 to i16, !dbg !370
  %93 = getelementptr inbounds %struct.pkt_meta, %struct.pkt_meta* %2, i64 0, i32 6, !dbg !371
  store i16 %92, i16* %93, align 2, !dbg !372, !tbaa !373
  %94 = zext i32 %90 to i64, !dbg !374
  %95 = sub nsw i64 %91, %94, !dbg !375
  %96 = trunc i64 %95 to i16, !dbg !376
  %97 = getelementptr inbounds %struct.pkt_meta, %struct.pkt_meta* %2, i64 0, i32 5, !dbg !377
  store i16 %96, i16* %97, align 4, !dbg !378, !tbaa !379
  %98 = bitcast %struct.xdp_md* %0 to i8*, !dbg !380
  %99 = shl i64 %91, 32, !dbg !381
  %100 = and i64 %99, 281470681743360, !dbg !381
  %101 = or i64 %100, 4294967295, !dbg !382
  %102 = call i32 inttoptr (i64 25 to i32 (i8*, i8*, i64, i8*, i32)*)(i8* %98, i8* bitcast (%struct.bpf_map_def* @perf_map to i8*), i64 %101, i8* nonnull %11, i32 48) #6, !dbg !383
  br label %103, !dbg !384

103:                                              ; preds = %23, %20, %74, %58, %36, %51, %1, %89
  call void @llvm.lifetime.end.p0i8(i64 48, i8* nonnull %11) #6, !dbg !385
  ret i32 2, !dbg !385
}

; Function Attrs: mustprogress nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #3

; Function Attrs: mustprogress nofree nosync nounwind readnone speculatable willreturn
declare i16 @llvm.bswap.i16(i16) #1

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #4

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
!llvm.module.flags = !{!73, !74, !75, !76}
!llvm.ident = !{!77}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "perf_map", scope: !2, file: !3, line: 18, type: !65, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 13.0.1 (https://github.com/llvm/llvm-project.git 19b8368225dc9ec5a0da547eae48c10dae13522d)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !43, globals: !51, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "prog.bpf.c", directory: "/home/thais/Documents/Master/eBPF/benchmark/programs/xdpdump")
!4 = !{!5, !14}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 3150, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/include/linux/bpf.h", directory: "")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2)
!12 = !DIEnumerator(name: "XDP_TX", value: 3)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!14 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !15, line: 28, baseType: !7, size: 32, elements: !16)
!15 = !DIFile(filename: "/usr/include/linux/in.h", directory: "")
!16 = !{!17, !18, !19, !20, !21, !22, !23, !24, !25, !26, !27, !28, !29, !30, !31, !32, !33, !34, !35, !36, !37, !38, !39, !40, !41, !42}
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
!38 = !DIEnumerator(name: "IPPROTO_SCTP", value: 132)
!39 = !DIEnumerator(name: "IPPROTO_UDPLITE", value: 136)
!40 = !DIEnumerator(name: "IPPROTO_MPLS", value: 137)
!41 = !DIEnumerator(name: "IPPROTO_RAW", value: 255)
!42 = !DIEnumerator(name: "IPPROTO_MAX", value: 256)
!43 = !{!44, !45, !46, !49}
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!45 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !47, line: 24, baseType: !48)
!47 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "")
!48 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !47, line: 31, baseType: !50)
!50 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!51 = !{!0, !52, !58}
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 150, type: !54, isLocal: false, isDefinition: true)
!54 = !DICompositeType(tag: DW_TAG_array_type, baseType: !55, size: 104, elements: !56)
!55 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!56 = !{!57}
!57 = !DISubrange(count: 13)
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(name: "bpf_perf_event_output", scope: !2, file: !60, line: 43, type: !61, isLocal: true, isDefinition: true)
!60 = !DIFile(filename: "../../libs/libbpf/src/../../headers/bpf_helpers.h", directory: "/home/thais/Documents/Master/eBPF/benchmark/programs/xdpdump")
!61 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !62, size: 64)
!62 = !DISubroutineType(types: !63)
!63 = !{!64, !44, !44, !50, !44, !64}
!64 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!65 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !60, line: 80, size: 192, elements: !66)
!66 = !{!67, !68, !69, !70, !71, !72}
!67 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !65, file: !60, line: 81, baseType: !7, size: 32)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !65, file: !60, line: 82, baseType: !7, size: 32, offset: 32)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !65, file: !60, line: 83, baseType: !7, size: 32, offset: 64)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !65, file: !60, line: 84, baseType: !7, size: 32, offset: 96)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !65, file: !60, line: 85, baseType: !7, size: 32, offset: 128)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "inner_map_idx", scope: !65, file: !60, line: 86, baseType: !7, size: 32, offset: 160)
!73 = !{i32 7, !"Dwarf Version", i32 4}
!74 = !{i32 2, !"Debug Info Version", i32 3}
!75 = !{i32 1, !"wchar_size", i32 4}
!76 = !{i32 7, !"frame-pointer", i32 2}
!77 = !{!"clang version 13.0.1 (https://github.com/llvm/llvm-project.git 19b8368225dc9ec5a0da547eae48c10dae13522d)"}
!78 = distinct !DISubprogram(name: "process_packet", scope: !3, file: !3, line: 91, type: !79, scopeLine: 92, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !90)
!79 = !DISubroutineType(types: !80)
!80 = !{!64, !81}
!81 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !82, size: 64)
!82 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 3161, size: 160, elements: !83)
!83 = !{!84, !86, !87, !88, !89}
!84 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !82, file: !6, line: 3162, baseType: !85, size: 32)
!85 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !47, line: 27, baseType: !7)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !82, file: !6, line: 3163, baseType: !85, size: 32, offset: 32)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !82, file: !6, line: 3164, baseType: !85, size: 32, offset: 64)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !82, file: !6, line: 3166, baseType: !85, size: 32, offset: 96)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !82, file: !6, line: 3167, baseType: !85, size: 32, offset: 128)
!90 = !{!91, !92, !93, !94, !108, !135}
!91 = !DILocalVariable(name: "ctx", arg: 1, scope: !78, file: !3, line: 91, type: !81)
!92 = !DILocalVariable(name: "data_end", scope: !78, file: !3, line: 93, type: !44)
!93 = !DILocalVariable(name: "data", scope: !78, file: !3, line: 94, type: !44)
!94 = !DILocalVariable(name: "eth", scope: !78, file: !3, line: 95, type: !95)
!95 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !96, size: 64)
!96 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !97, line: 163, size: 112, elements: !98)
!97 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "")
!98 = !{!99, !104, !105}
!99 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !96, file: !97, line: 164, baseType: !100, size: 48)
!100 = !DICompositeType(tag: DW_TAG_array_type, baseType: !101, size: 48, elements: !102)
!101 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!102 = !{!103}
!103 = !DISubrange(count: 6)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !96, file: !97, line: 165, baseType: !100, size: 48, offset: 48)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !96, file: !97, line: 166, baseType: !106, size: 16, offset: 96)
!106 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !107, line: 25, baseType: !46)
!107 = !DIFile(filename: "/usr/include/linux/types.h", directory: "")
!108 = !DILocalVariable(name: "pkt", scope: !78, file: !3, line: 96, type: !109)
!109 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "pkt_meta", file: !110, line: 5, size: 384, elements: !111)
!110 = !DIFile(filename: "./prog.h", directory: "/home/thais/Documents/Master/eBPF/benchmark/programs/xdpdump")
!111 = !{!112, !121, !126, !130, !131, !132, !133, !134}
!112 = !DIDerivedType(tag: DW_TAG_member, scope: !109, file: !110, line: 7, baseType: !113, size: 128)
!113 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !109, file: !110, line: 7, size: 128, elements: !114)
!114 = !{!115, !117}
!115 = !DIDerivedType(tag: DW_TAG_member, name: "src", scope: !113, file: !110, line: 9, baseType: !116, size: 32)
!116 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !107, line: 27, baseType: !85)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "srcv6", scope: !113, file: !110, line: 10, baseType: !118, size: 128)
!118 = !DICompositeType(tag: DW_TAG_array_type, baseType: !116, size: 128, elements: !119)
!119 = !{!120}
!120 = !DISubrange(count: 4)
!121 = !DIDerivedType(tag: DW_TAG_member, scope: !109, file: !110, line: 12, baseType: !122, size: 128, offset: 128)
!122 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !109, file: !110, line: 12, size: 128, elements: !123)
!123 = !{!124, !125}
!124 = !DIDerivedType(tag: DW_TAG_member, name: "dst", scope: !122, file: !110, line: 14, baseType: !116, size: 32)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "dstv6", scope: !122, file: !110, line: 15, baseType: !118, size: 128)
!126 = !DIDerivedType(tag: DW_TAG_member, name: "port16", scope: !109, file: !110, line: 17, baseType: !127, size: 32, offset: 256)
!127 = !DICompositeType(tag: DW_TAG_array_type, baseType: !46, size: 32, elements: !128)
!128 = !{!129}
!129 = !DISubrange(count: 2)
!130 = !DIDerivedType(tag: DW_TAG_member, name: "l3_proto", scope: !109, file: !110, line: 18, baseType: !46, size: 16, offset: 288)
!131 = !DIDerivedType(tag: DW_TAG_member, name: "l4_proto", scope: !109, file: !110, line: 19, baseType: !46, size: 16, offset: 304)
!132 = !DIDerivedType(tag: DW_TAG_member, name: "data_len", scope: !109, file: !110, line: 20, baseType: !46, size: 16, offset: 320)
!133 = !DIDerivedType(tag: DW_TAG_member, name: "pkt_len", scope: !109, file: !110, line: 21, baseType: !46, size: 16, offset: 336)
!134 = !DIDerivedType(tag: DW_TAG_member, name: "seq", scope: !109, file: !110, line: 22, baseType: !85, size: 32, offset: 352)
!135 = !DILocalVariable(name: "off", scope: !78, file: !3, line: 97, type: !85)
!136 = !DILocation(line: 0, scope: !78)
!137 = !DILocation(line: 93, column: 38, scope: !78)
!138 = !{!139, !140, i64 4}
!139 = !{!"xdp_md", !140, i64 0, !140, i64 4, !140, i64 8, !140, i64 12, !140, i64 16}
!140 = !{!"int", !141, i64 0}
!141 = !{!"omnipotent char", !142, i64 0}
!142 = !{!"Simple C/C++ TBAA"}
!143 = !DILocation(line: 93, column: 27, scope: !78)
!144 = !DILocation(line: 93, column: 19, scope: !78)
!145 = !DILocation(line: 94, column: 34, scope: !78)
!146 = !{!139, !140, i64 0}
!147 = !DILocation(line: 94, column: 23, scope: !78)
!148 = !DILocation(line: 94, column: 15, scope: !78)
!149 = !DILocation(line: 96, column: 2, scope: !78)
!150 = !DILocation(line: 96, column: 18, scope: !78)
!151 = !DILocation(line: 101, column: 11, scope: !152)
!152 = distinct !DILexicalBlock(scope: !78, file: !3, line: 101, column: 6)
!153 = !DILocation(line: 101, column: 17, scope: !152)
!154 = !DILocation(line: 101, column: 6, scope: !78)
!155 = !DILocation(line: 95, column: 23, scope: !78)
!156 = !DILocation(line: 104, column: 17, scope: !78)
!157 = !{!158, !159, i64 12}
!158 = !{!"ethhdr", !141, i64 0, !141, i64 6, !159, i64 12}
!159 = !{!"short", !141, i64 0}
!160 = !DILocation(line: 104, column: 6, scope: !78)
!161 = !DILocation(line: 104, column: 15, scope: !78)
!162 = !{!163, !159, i64 36}
!163 = !{!"pkt_meta", !141, i64 0, !141, i64 16, !141, i64 32, !159, i64 36, !159, i64 38, !159, i64 40, !159, i64 42, !140, i64 44}
!164 = !DILocation(line: 106, column: 6, scope: !78)
!165 = !DILocalVariable(name: "data", arg: 1, scope: !166, file: !3, line: 55, type: !44)
!166 = distinct !DISubprogram(name: "parse_ip4", scope: !3, file: !3, line: 55, type: !167, scopeLine: 57, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !171)
!167 = !DISubroutineType(types: !168)
!168 = !{!169, !44, !49, !44, !170}
!169 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!170 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !109, size: 64)
!171 = !{!165, !172, !173, !174, !175}
!172 = !DILocalVariable(name: "off", arg: 2, scope: !166, file: !3, line: 55, type: !49)
!173 = !DILocalVariable(name: "data_end", arg: 3, scope: !166, file: !3, line: 55, type: !44)
!174 = !DILocalVariable(name: "pkt", arg: 4, scope: !166, file: !3, line: 56, type: !170)
!175 = !DILocalVariable(name: "iph", scope: !166, file: !3, line: 58, type: !176)
!176 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !177, size: 64)
!177 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !178, line: 86, size: 160, elements: !179)
!178 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "")
!179 = !{!180, !182, !183, !184, !185, !186, !187, !188, !189, !191, !192}
!180 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !177, file: !178, line: 88, baseType: !181, size: 4, flags: DIFlagBitField, extraData: i64 0)
!181 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !47, line: 21, baseType: !101)
!182 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !177, file: !178, line: 89, baseType: !181, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!183 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !177, file: !178, line: 96, baseType: !181, size: 8, offset: 8)
!184 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !177, file: !178, line: 97, baseType: !106, size: 16, offset: 16)
!185 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !177, file: !178, line: 98, baseType: !106, size: 16, offset: 32)
!186 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !177, file: !178, line: 99, baseType: !106, size: 16, offset: 48)
!187 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !177, file: !178, line: 100, baseType: !181, size: 8, offset: 64)
!188 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !177, file: !178, line: 101, baseType: !181, size: 8, offset: 72)
!189 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !177, file: !178, line: 102, baseType: !190, size: 16, offset: 80)
!190 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !107, line: 31, baseType: !46)
!191 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !177, file: !178, line: 103, baseType: !116, size: 32, offset: 96)
!192 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !177, file: !178, line: 104, baseType: !116, size: 32, offset: 128)
!193 = !DILocation(line: 0, scope: !166, inlinedAt: !194)
!194 = distinct !DILocation(line: 108, column: 8, scope: !195)
!195 = distinct !DILexicalBlock(scope: !196, file: !3, line: 108, column: 7)
!196 = distinct !DILexicalBlock(scope: !197, file: !3, line: 107, column: 2)
!197 = distinct !DILexicalBlock(scope: !78, file: !3, line: 106, column: 6)
!198 = !DILocation(line: 61, column: 17, scope: !199, inlinedAt: !194)
!199 = distinct !DILexicalBlock(scope: !166, file: !3, line: 61, column: 6)
!200 = !DILocation(line: 61, column: 40, scope: !199, inlinedAt: !194)
!201 = !DILocation(line: 61, column: 6, scope: !166, inlinedAt: !194)
!202 = !DILocation(line: 64, column: 11, scope: !203, inlinedAt: !194)
!203 = distinct !DILexicalBlock(scope: !166, file: !3, line: 64, column: 6)
!204 = !DILocation(line: 64, column: 15, scope: !203, inlinedAt: !194)
!205 = !DILocation(line: 64, column: 6, scope: !166, inlinedAt: !194)
!206 = !DILocation(line: 67, column: 18, scope: !166, inlinedAt: !194)
!207 = !{!208, !140, i64 12}
!208 = !{!"iphdr", !141, i64 0, !141, i64 0, !141, i64 1, !159, i64 2, !159, i64 4, !159, i64 6, !141, i64 8, !141, i64 9, !159, i64 10, !140, i64 12, !140, i64 16}
!209 = !DILocation(line: 67, column: 7, scope: !166, inlinedAt: !194)
!210 = !DILocation(line: 67, column: 11, scope: !166, inlinedAt: !194)
!211 = !{!141, !141, i64 0}
!212 = !DILocation(line: 68, column: 18, scope: !166, inlinedAt: !194)
!213 = !{!208, !140, i64 16}
!214 = !DILocation(line: 68, column: 7, scope: !166, inlinedAt: !194)
!215 = !DILocation(line: 68, column: 11, scope: !166, inlinedAt: !194)
!216 = !DILocation(line: 108, column: 7, scope: !196)
!217 = !DILocalVariable(name: "data", arg: 1, scope: !218, file: !3, line: 74, type: !44)
!218 = distinct !DISubprogram(name: "parse_ip6", scope: !3, file: !3, line: 74, type: !167, scopeLine: 76, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !219)
!219 = !{!217, !220, !221, !222, !223}
!220 = !DILocalVariable(name: "off", arg: 2, scope: !218, file: !3, line: 74, type: !49)
!221 = !DILocalVariable(name: "data_end", arg: 3, scope: !218, file: !3, line: 74, type: !44)
!222 = !DILocalVariable(name: "pkt", arg: 4, scope: !218, file: !3, line: 75, type: !170)
!223 = !DILocalVariable(name: "ip6h", scope: !218, file: !3, line: 77, type: !224)
!224 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !225, size: 64)
!225 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ipv6hdr", file: !226, line: 116, size: 320, elements: !227)
!226 = !DIFile(filename: "/usr/include/linux/ipv6.h", directory: "")
!227 = !{!228, !229, !230, !234, !235, !236, !237, !253}
!228 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !225, file: !226, line: 118, baseType: !181, size: 4, flags: DIFlagBitField, extraData: i64 0)
!229 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !225, file: !226, line: 119, baseType: !181, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!230 = !DIDerivedType(tag: DW_TAG_member, name: "flow_lbl", scope: !225, file: !226, line: 126, baseType: !231, size: 24, offset: 8)
!231 = !DICompositeType(tag: DW_TAG_array_type, baseType: !181, size: 24, elements: !232)
!232 = !{!233}
!233 = !DISubrange(count: 3)
!234 = !DIDerivedType(tag: DW_TAG_member, name: "payload_len", scope: !225, file: !226, line: 128, baseType: !106, size: 16, offset: 32)
!235 = !DIDerivedType(tag: DW_TAG_member, name: "nexthdr", scope: !225, file: !226, line: 129, baseType: !181, size: 8, offset: 48)
!236 = !DIDerivedType(tag: DW_TAG_member, name: "hop_limit", scope: !225, file: !226, line: 130, baseType: !181, size: 8, offset: 56)
!237 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !225, file: !226, line: 132, baseType: !238, size: 128, offset: 64)
!238 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "in6_addr", file: !239, line: 33, size: 128, elements: !240)
!239 = !DIFile(filename: "/usr/include/linux/in6.h", directory: "")
!240 = !{!241}
!241 = !DIDerivedType(tag: DW_TAG_member, name: "in6_u", scope: !238, file: !239, line: 40, baseType: !242, size: 128)
!242 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !238, file: !239, line: 34, size: 128, elements: !243)
!243 = !{!244, !248, !252}
!244 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr8", scope: !242, file: !239, line: 35, baseType: !245, size: 128)
!245 = !DICompositeType(tag: DW_TAG_array_type, baseType: !181, size: 128, elements: !246)
!246 = !{!247}
!247 = !DISubrange(count: 16)
!248 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr16", scope: !242, file: !239, line: 37, baseType: !249, size: 128)
!249 = !DICompositeType(tag: DW_TAG_array_type, baseType: !106, size: 128, elements: !250)
!250 = !{!251}
!251 = !DISubrange(count: 8)
!252 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr32", scope: !242, file: !239, line: 38, baseType: !118, size: 128)
!253 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !225, file: !226, line: 133, baseType: !238, size: 128, offset: 192)
!254 = !DILocation(line: 0, scope: !218, inlinedAt: !255)
!255 = distinct !DILocation(line: 114, column: 8, scope: !256)
!256 = distinct !DILexicalBlock(scope: !257, file: !3, line: 114, column: 7)
!257 = distinct !DILexicalBlock(scope: !258, file: !3, line: 113, column: 2)
!258 = distinct !DILexicalBlock(scope: !197, file: !3, line: 112, column: 11)
!259 = !DILocation(line: 80, column: 17, scope: !260, inlinedAt: !255)
!260 = distinct !DILexicalBlock(scope: !218, file: !3, line: 80, column: 6)
!261 = !DILocation(line: 80, column: 42, scope: !260, inlinedAt: !255)
!262 = !DILocation(line: 80, column: 6, scope: !218, inlinedAt: !255)
!263 = !DILocation(line: 83, column: 27, scope: !218, inlinedAt: !255)
!264 = !DILocation(line: 83, column: 2, scope: !218, inlinedAt: !255)
!265 = !DILocation(line: 84, column: 2, scope: !218, inlinedAt: !255)
!266 = !DILocation(line: 84, column: 27, scope: !218, inlinedAt: !255)
!267 = !DILocation(line: 114, column: 7, scope: !257)
!268 = !DILocation(line: 0, scope: !197)
!269 = !{!163, !159, i64 38}
!270 = !DILocation(line: 119, column: 11, scope: !271)
!271 = distinct !DILexicalBlock(scope: !78, file: !3, line: 119, column: 6)
!272 = !DILocation(line: 119, column: 17, scope: !271)
!273 = !DILocation(line: 119, column: 6, scope: !78)
!274 = !DILocation(line: 123, column: 6, scope: !78)
!275 = !DILocalVariable(name: "data", arg: 1, scope: !276, file: !3, line: 39, type: !44)
!276 = distinct !DISubprogram(name: "parse_tcp", scope: !3, file: !3, line: 39, type: !167, scopeLine: 41, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !277)
!277 = !{!275, !278, !279, !280, !281}
!278 = !DILocalVariable(name: "off", arg: 2, scope: !276, file: !3, line: 39, type: !49)
!279 = !DILocalVariable(name: "data_end", arg: 3, scope: !276, file: !3, line: 39, type: !44)
!280 = !DILocalVariable(name: "pkt", arg: 4, scope: !276, file: !3, line: 40, type: !170)
!281 = !DILocalVariable(name: "tcp", scope: !276, file: !3, line: 42, type: !282)
!282 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !283, size: 64)
!283 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "tcphdr", file: !284, line: 25, size: 160, elements: !285)
!284 = !DIFile(filename: "/usr/include/linux/tcp.h", directory: "")
!285 = !{!286, !287, !288, !289, !290, !291, !292, !293, !294, !295, !296, !297, !298, !299, !300, !301, !302}
!286 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !283, file: !284, line: 26, baseType: !106, size: 16)
!287 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !283, file: !284, line: 27, baseType: !106, size: 16, offset: 16)
!288 = !DIDerivedType(tag: DW_TAG_member, name: "seq", scope: !283, file: !284, line: 28, baseType: !116, size: 32, offset: 32)
!289 = !DIDerivedType(tag: DW_TAG_member, name: "ack_seq", scope: !283, file: !284, line: 29, baseType: !116, size: 32, offset: 64)
!290 = !DIDerivedType(tag: DW_TAG_member, name: "res1", scope: !283, file: !284, line: 31, baseType: !46, size: 4, offset: 96, flags: DIFlagBitField, extraData: i64 96)
!291 = !DIDerivedType(tag: DW_TAG_member, name: "doff", scope: !283, file: !284, line: 32, baseType: !46, size: 4, offset: 100, flags: DIFlagBitField, extraData: i64 96)
!292 = !DIDerivedType(tag: DW_TAG_member, name: "fin", scope: !283, file: !284, line: 33, baseType: !46, size: 1, offset: 104, flags: DIFlagBitField, extraData: i64 96)
!293 = !DIDerivedType(tag: DW_TAG_member, name: "syn", scope: !283, file: !284, line: 34, baseType: !46, size: 1, offset: 105, flags: DIFlagBitField, extraData: i64 96)
!294 = !DIDerivedType(tag: DW_TAG_member, name: "rst", scope: !283, file: !284, line: 35, baseType: !46, size: 1, offset: 106, flags: DIFlagBitField, extraData: i64 96)
!295 = !DIDerivedType(tag: DW_TAG_member, name: "psh", scope: !283, file: !284, line: 36, baseType: !46, size: 1, offset: 107, flags: DIFlagBitField, extraData: i64 96)
!296 = !DIDerivedType(tag: DW_TAG_member, name: "ack", scope: !283, file: !284, line: 37, baseType: !46, size: 1, offset: 108, flags: DIFlagBitField, extraData: i64 96)
!297 = !DIDerivedType(tag: DW_TAG_member, name: "urg", scope: !283, file: !284, line: 38, baseType: !46, size: 1, offset: 109, flags: DIFlagBitField, extraData: i64 96)
!298 = !DIDerivedType(tag: DW_TAG_member, name: "ece", scope: !283, file: !284, line: 39, baseType: !46, size: 1, offset: 110, flags: DIFlagBitField, extraData: i64 96)
!299 = !DIDerivedType(tag: DW_TAG_member, name: "cwr", scope: !283, file: !284, line: 40, baseType: !46, size: 1, offset: 111, flags: DIFlagBitField, extraData: i64 96)
!300 = !DIDerivedType(tag: DW_TAG_member, name: "window", scope: !283, file: !284, line: 55, baseType: !106, size: 16, offset: 112)
!301 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !283, file: !284, line: 56, baseType: !190, size: 16, offset: 128)
!302 = !DIDerivedType(tag: DW_TAG_member, name: "urg_ptr", scope: !283, file: !284, line: 57, baseType: !106, size: 16, offset: 144)
!303 = !DILocation(line: 0, scope: !276, inlinedAt: !304)
!304 = distinct !DILocation(line: 125, column: 8, scope: !305)
!305 = distinct !DILexicalBlock(scope: !306, file: !3, line: 125, column: 7)
!306 = distinct !DILexicalBlock(scope: !307, file: !3, line: 124, column: 2)
!307 = distinct !DILexicalBlock(scope: !78, file: !3, line: 123, column: 6)
!308 = !DILocation(line: 45, column: 17, scope: !309, inlinedAt: !304)
!309 = distinct !DILexicalBlock(scope: !276, file: !3, line: 45, column: 6)
!310 = !DILocation(line: 45, column: 41, scope: !309, inlinedAt: !304)
!311 = !DILocation(line: 45, column: 6, scope: !276, inlinedAt: !304)
!312 = !DILocation(line: 48, column: 24, scope: !276, inlinedAt: !304)
!313 = !{!314, !159, i64 0}
!314 = !{!"tcphdr", !159, i64 0, !159, i64 2, !140, i64 4, !140, i64 8, !159, i64 12, !159, i64 12, !159, i64 13, !159, i64 13, !159, i64 13, !159, i64 13, !159, i64 13, !159, i64 13, !159, i64 13, !159, i64 13, !159, i64 14, !159, i64 16, !159, i64 18}
!315 = !DILocation(line: 48, column: 2, scope: !276, inlinedAt: !304)
!316 = !DILocation(line: 48, column: 17, scope: !276, inlinedAt: !304)
!317 = !{!159, !159, i64 0}
!318 = !DILocation(line: 49, column: 24, scope: !276, inlinedAt: !304)
!319 = !{!314, !159, i64 2}
!320 = !DILocation(line: 49, column: 2, scope: !276, inlinedAt: !304)
!321 = !DILocation(line: 49, column: 17, scope: !276, inlinedAt: !304)
!322 = !DILocation(line: 50, column: 18, scope: !276, inlinedAt: !304)
!323 = !{!314, !140, i64 4}
!324 = !DILocation(line: 50, column: 7, scope: !276, inlinedAt: !304)
!325 = !DILocation(line: 50, column: 11, scope: !276, inlinedAt: !304)
!326 = !{!163, !140, i64 44}
!327 = !DILocation(line: 127, column: 7, scope: !306)
!328 = !DILocation(line: 128, column: 2, scope: !306)
!329 = !DILocalVariable(name: "data", arg: 1, scope: !330, file: !3, line: 25, type: !44)
!330 = distinct !DISubprogram(name: "parse_udp", scope: !3, file: !3, line: 25, type: !167, scopeLine: 27, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !331)
!331 = !{!329, !332, !333, !334, !335}
!332 = !DILocalVariable(name: "off", arg: 2, scope: !330, file: !3, line: 25, type: !49)
!333 = !DILocalVariable(name: "data_end", arg: 3, scope: !330, file: !3, line: 25, type: !44)
!334 = !DILocalVariable(name: "pkt", arg: 4, scope: !330, file: !3, line: 26, type: !170)
!335 = !DILocalVariable(name: "udp", scope: !330, file: !3, line: 28, type: !336)
!336 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !337, size: 64)
!337 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "udphdr", file: !338, line: 23, size: 64, elements: !339)
!338 = !DIFile(filename: "/usr/include/linux/udp.h", directory: "")
!339 = !{!340, !341, !342, !343}
!340 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !337, file: !338, line: 24, baseType: !106, size: 16)
!341 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !337, file: !338, line: 25, baseType: !106, size: 16, offset: 16)
!342 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !337, file: !338, line: 26, baseType: !106, size: 16, offset: 32)
!343 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !337, file: !338, line: 27, baseType: !190, size: 16, offset: 48)
!344 = !DILocation(line: 0, scope: !330, inlinedAt: !345)
!345 = distinct !DILocation(line: 131, column: 8, scope: !346)
!346 = distinct !DILexicalBlock(scope: !347, file: !3, line: 131, column: 7)
!347 = distinct !DILexicalBlock(scope: !348, file: !3, line: 130, column: 2)
!348 = distinct !DILexicalBlock(scope: !307, file: !3, line: 129, column: 11)
!349 = !DILocation(line: 31, column: 17, scope: !350, inlinedAt: !345)
!350 = distinct !DILexicalBlock(scope: !330, file: !3, line: 31, column: 6)
!351 = !DILocation(line: 31, column: 41, scope: !350, inlinedAt: !345)
!352 = !DILocation(line: 31, column: 6, scope: !330, inlinedAt: !345)
!353 = !DILocation(line: 34, column: 24, scope: !330, inlinedAt: !345)
!354 = !{!355, !159, i64 0}
!355 = !{!"udphdr", !159, i64 0, !159, i64 2, !159, i64 4, !159, i64 6}
!356 = !DILocation(line: 34, column: 2, scope: !330, inlinedAt: !345)
!357 = !DILocation(line: 34, column: 17, scope: !330, inlinedAt: !345)
!358 = !DILocation(line: 35, column: 24, scope: !330, inlinedAt: !345)
!359 = !{!355, !159, i64 2}
!360 = !DILocation(line: 35, column: 2, scope: !330, inlinedAt: !345)
!361 = !DILocation(line: 35, column: 17, scope: !330, inlinedAt: !345)
!362 = !DILocation(line: 133, column: 7, scope: !347)
!363 = !DILocation(line: 134, column: 2, scope: !347)
!364 = !DILocation(line: 137, column: 3, scope: !365)
!365 = distinct !DILexicalBlock(scope: !348, file: !3, line: 136, column: 2)
!366 = !DILocation(line: 137, column: 17, scope: !365)
!367 = !DILocation(line: 138, column: 3, scope: !365)
!368 = !DILocation(line: 138, column: 17, scope: !365)
!369 = !DILocation(line: 141, column: 25, scope: !78)
!370 = !DILocation(line: 141, column: 16, scope: !78)
!371 = !DILocation(line: 141, column: 6, scope: !78)
!372 = !DILocation(line: 141, column: 14, scope: !78)
!373 = !{!163, !159, i64 42}
!374 = !DILocation(line: 142, column: 35, scope: !78)
!375 = !DILocation(line: 142, column: 33, scope: !78)
!376 = !DILocation(line: 142, column: 17, scope: !78)
!377 = !DILocation(line: 142, column: 6, scope: !78)
!378 = !DILocation(line: 142, column: 15, scope: !78)
!379 = !{!163, !159, i64 40}
!380 = !DILocation(line: 144, column: 24, scope: !78)
!381 = !DILocation(line: 145, column: 28, scope: !78)
!382 = !DILocation(line: 145, column: 34, scope: !78)
!383 = !DILocation(line: 144, column: 2, scope: !78)
!384 = !DILocation(line: 147, column: 2, scope: !78)
!385 = !DILocation(line: 148, column: 1, scope: !78)
