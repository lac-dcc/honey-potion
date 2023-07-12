; ModuleID = '/run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/benchmarks/xdpdump/prog.bpf.c'
source_filename = "/run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/benchmarks/xdpdump/prog.bpf.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.anon = type { ptr, ptr, ptr, ptr }
%struct.pkt_meta = type { %union.anon, %union.anon.0, [2 x i16], i16, i16, i16, i16, i32 }
%union.anon = type { [4 x i32] }
%union.anon.0 = type { [4 x i32] }
%struct.xdp_md = type { i32, i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.tcphdr = type { i16, i16, i32, i32, i16, i16, i16, i16 }
%struct.udphdr = type { i16, i16, i16, i16 }

@perf_map = dso_local global %struct.anon zeroinitializer, section ".maps", align 8, !dbg !0
@_license = dso_local global [13 x i8] c"Dual BSD/GPL\00", section "license", align 1, !dbg !61
@llvm.compiler.used = appending global [3 x ptr] [ptr @_license, ptr @perf_map, ptr @process_packet], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @process_packet(ptr noundef %0) #0 section "xdp" !dbg !96 {
  %2 = alloca %struct.pkt_meta, align 4
  call void @llvm.dbg.value(metadata ptr %0, metadata !109, metadata !DIExpression()), !dbg !152
  %3 = getelementptr inbounds %struct.xdp_md, ptr %0, i64 0, i32 1, !dbg !153
  %4 = load i32, ptr %3, align 4, !dbg !153, !tbaa !154
  %5 = zext i32 %4 to i64, !dbg !159
  %6 = inttoptr i64 %5 to ptr, !dbg !160
  call void @llvm.dbg.value(metadata ptr %6, metadata !110, metadata !DIExpression()), !dbg !152
  %7 = load i32, ptr %0, align 4, !dbg !161, !tbaa !162
  %8 = zext i32 %7 to i64, !dbg !163
  %9 = inttoptr i64 %8 to ptr, !dbg !164
  call void @llvm.dbg.value(metadata ptr %9, metadata !111, metadata !DIExpression()), !dbg !152
  call void @llvm.dbg.value(metadata ptr %9, metadata !112, metadata !DIExpression()), !dbg !152
  call void @llvm.lifetime.start.p0(i64 48, ptr nonnull %2) #6, !dbg !165
  call void @llvm.dbg.declare(metadata ptr %2, metadata !126, metadata !DIExpression()), !dbg !166
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(48) %2, i8 0, i64 48, i1 false), !dbg !166
  call void @llvm.dbg.value(metadata i32 14, metadata !151, metadata !DIExpression()), !dbg !152
  %10 = getelementptr i8, ptr %9, i64 14, !dbg !167
  %11 = icmp ugt ptr %10, %6, !dbg !169
  br i1 %11, label %90, label %12, !dbg !170

12:                                               ; preds = %1
  %13 = getelementptr inbounds %struct.ethhdr, ptr %9, i64 0, i32 2, !dbg !171
  %14 = load i16, ptr %13, align 1, !dbg !171, !tbaa !172
  %15 = tail call i16 @llvm.bswap.i16(i16 %14), !dbg !171
  %16 = getelementptr inbounds %struct.pkt_meta, ptr %2, i64 0, i32 3, !dbg !175
  store i16 %15, ptr %16, align 4, !dbg !176, !tbaa !177
  switch i16 %15, label %44 [
    i16 2048, label %17
    i16 -31011, label %30
  ], !dbg !179

17:                                               ; preds = %12
  call void @llvm.dbg.value(metadata ptr %9, metadata !180, metadata !DIExpression()), !dbg !219
  call void @llvm.dbg.value(metadata i64 14, metadata !187, metadata !DIExpression()), !dbg !219
  call void @llvm.dbg.value(metadata ptr %6, metadata !188, metadata !DIExpression()), !dbg !219
  call void @llvm.dbg.value(metadata ptr %2, metadata !189, metadata !DIExpression()), !dbg !219
  call void @llvm.dbg.value(metadata ptr %9, metadata !190, metadata !DIExpression(DW_OP_plus_uconst, 14, DW_OP_stack_value)), !dbg !219
  %18 = getelementptr i8, ptr %9, i64 34, !dbg !224
  %19 = icmp ugt ptr %18, %6, !dbg !226
  br i1 %19, label %90, label %20, !dbg !227

20:                                               ; preds = %17
  call void @llvm.dbg.value(metadata ptr %10, metadata !190, metadata !DIExpression()), !dbg !219
  %21 = load i8, ptr %10, align 4, !dbg !228
  %22 = and i8 %21, 15, !dbg !228
  %23 = icmp eq i8 %22, 5, !dbg !230
  br i1 %23, label %24, label %90, !dbg !231

24:                                               ; preds = %20
  %25 = getelementptr i8, ptr %9, i64 26, !dbg !232
  %26 = load i32, ptr %25, align 4, !dbg !232, !tbaa !233
  store i32 %26, ptr %2, align 4, !dbg !234, !tbaa !233
  %27 = getelementptr i8, ptr %9, i64 30, !dbg !235
  %28 = load i32, ptr %27, align 4, !dbg !235, !tbaa !233
  %29 = getelementptr inbounds %struct.pkt_meta, ptr %2, i64 0, i32 1, !dbg !236
  store i32 %28, ptr %29, align 4, !dbg !237, !tbaa !233
  br label %37, !dbg !238

30:                                               ; preds = %12
  call void @llvm.dbg.value(metadata ptr %9, metadata !239, metadata !DIExpression()), !dbg !287
  call void @llvm.dbg.value(metadata i64 14, metadata !242, metadata !DIExpression()), !dbg !287
  call void @llvm.dbg.value(metadata ptr %6, metadata !243, metadata !DIExpression()), !dbg !287
  call void @llvm.dbg.value(metadata ptr %2, metadata !244, metadata !DIExpression()), !dbg !287
  call void @llvm.dbg.value(metadata ptr %9, metadata !245, metadata !DIExpression(DW_OP_plus_uconst, 14, DW_OP_stack_value)), !dbg !287
  %31 = getelementptr i8, ptr %9, i64 54, !dbg !292
  %32 = icmp ugt ptr %31, %6, !dbg !294
  br i1 %32, label %90, label %33, !dbg !295

33:                                               ; preds = %30
  call void @llvm.dbg.value(metadata ptr %9, metadata !245, metadata !DIExpression(DW_OP_plus_uconst, 14, DW_OP_stack_value)), !dbg !287
  %34 = getelementptr i8, ptr %9, i64 22, !dbg !296
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(16) %2, ptr noundef nonnull align 4 dereferenceable(16) %34, i64 16, i1 false), !dbg !297
  %35 = getelementptr inbounds %struct.pkt_meta, ptr %2, i64 0, i32 1, !dbg !298
  %36 = getelementptr i8, ptr %9, i64 38, !dbg !299
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(16) %35, ptr noundef nonnull align 4 dereferenceable(16) %36, i64 16, i1 false), !dbg !300
  br label %37, !dbg !301

37:                                               ; preds = %24, %33
  %38 = phi i64 [ 23, %24 ], [ 20, %33 ]
  %39 = phi i32 [ 34, %24 ], [ 54, %33 ]
  %40 = getelementptr i8, ptr %9, i64 %38, !dbg !302
  %41 = load i8, ptr %40, align 1, !dbg !302, !tbaa !233
  %42 = zext i8 %41 to i16, !dbg !302
  %43 = getelementptr inbounds %struct.pkt_meta, ptr %2, i64 0, i32 4, !dbg !302
  store i16 %42, ptr %43, align 2, !dbg !302, !tbaa !303
  br label %44, !dbg !304

44:                                               ; preds = %37, %12
  %45 = phi i8 [ 0, %12 ], [ %41, %37 ]
  %46 = phi i32 [ 14, %12 ], [ %39, %37 ], !dbg !152
  call void @llvm.dbg.value(metadata i32 %46, metadata !151, metadata !DIExpression()), !dbg !152
  %47 = zext i32 %46 to i64, !dbg !304
  %48 = getelementptr i8, ptr %9, i64 %47, !dbg !304
  %49 = icmp ugt ptr %48, %6, !dbg !306
  br i1 %49, label %90, label %50, !dbg !307

50:                                               ; preds = %44
  switch i8 %45, label %74 [
    i8 6, label %51
    i8 17, label %64
  ], !dbg !308

51:                                               ; preds = %50
  call void @llvm.dbg.value(metadata ptr %9, metadata !309, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata i64 %47, metadata !313, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata ptr %6, metadata !314, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata ptr %2, metadata !315, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata ptr %48, metadata !316, metadata !DIExpression()), !dbg !338
  %52 = getelementptr i8, ptr %48, i64 20, !dbg !343
  %53 = icmp ugt ptr %52, %6, !dbg !345
  br i1 %53, label %90, label %54, !dbg !346

54:                                               ; preds = %51
  %55 = load i16, ptr %48, align 4, !dbg !347, !tbaa !348
  %56 = getelementptr inbounds %struct.pkt_meta, ptr %2, i64 0, i32 2, !dbg !350
  store i16 %55, ptr %56, align 4, !dbg !351, !tbaa !352
  %57 = getelementptr inbounds %struct.tcphdr, ptr %48, i64 0, i32 1, !dbg !353
  %58 = load i16, ptr %57, align 2, !dbg !353, !tbaa !354
  %59 = getelementptr inbounds %struct.pkt_meta, ptr %2, i64 0, i32 2, i64 1, !dbg !355
  store i16 %58, ptr %59, align 2, !dbg !356, !tbaa !352
  %60 = getelementptr inbounds %struct.tcphdr, ptr %48, i64 0, i32 2, !dbg !357
  %61 = load i32, ptr %60, align 4, !dbg !357, !tbaa !358
  %62 = getelementptr inbounds %struct.pkt_meta, ptr %2, i64 0, i32 7, !dbg !359
  store i32 %61, ptr %62, align 4, !dbg !360, !tbaa !361
  %63 = add nuw nsw i32 %46, 20, !dbg !362
  call void @llvm.dbg.value(metadata i32 %63, metadata !151, metadata !DIExpression()), !dbg !152
  br label %77, !dbg !363

64:                                               ; preds = %50
  call void @llvm.dbg.value(metadata ptr %9, metadata !364, metadata !DIExpression()), !dbg !379
  call void @llvm.dbg.value(metadata i64 %47, metadata !367, metadata !DIExpression()), !dbg !379
  call void @llvm.dbg.value(metadata ptr %6, metadata !368, metadata !DIExpression()), !dbg !379
  call void @llvm.dbg.value(metadata ptr %2, metadata !369, metadata !DIExpression()), !dbg !379
  call void @llvm.dbg.value(metadata ptr %48, metadata !370, metadata !DIExpression()), !dbg !379
  %65 = getelementptr i8, ptr %48, i64 8, !dbg !384
  %66 = icmp ugt ptr %65, %6, !dbg !386
  br i1 %66, label %90, label %67, !dbg !387

67:                                               ; preds = %64
  %68 = load i16, ptr %48, align 2, !dbg !388, !tbaa !389
  %69 = getelementptr inbounds %struct.pkt_meta, ptr %2, i64 0, i32 2, !dbg !391
  store i16 %68, ptr %69, align 4, !dbg !392, !tbaa !352
  %70 = getelementptr inbounds %struct.udphdr, ptr %48, i64 0, i32 1, !dbg !393
  %71 = load i16, ptr %70, align 2, !dbg !393, !tbaa !394
  %72 = getelementptr inbounds %struct.pkt_meta, ptr %2, i64 0, i32 2, i64 1, !dbg !395
  store i16 %71, ptr %72, align 2, !dbg !396, !tbaa !352
  %73 = add nuw nsw i32 %46, 8, !dbg !397
  call void @llvm.dbg.value(metadata i32 %73, metadata !151, metadata !DIExpression()), !dbg !152
  br label %77, !dbg !398

74:                                               ; preds = %50
  %75 = getelementptr inbounds %struct.pkt_meta, ptr %2, i64 0, i32 2, !dbg !399
  store i16 0, ptr %75, align 4, !dbg !401, !tbaa !352
  %76 = getelementptr inbounds %struct.pkt_meta, ptr %2, i64 0, i32 2, i64 1, !dbg !402
  store i16 0, ptr %76, align 2, !dbg !403, !tbaa !352
  br label %77

77:                                               ; preds = %67, %74, %54
  %78 = phi i32 [ %63, %54 ], [ %73, %67 ], [ %46, %74 ], !dbg !152
  call void @llvm.dbg.value(metadata i32 %78, metadata !151, metadata !DIExpression()), !dbg !152
  %79 = sub nsw i64 %5, %8, !dbg !404
  %80 = trunc i64 %79 to i16, !dbg !405
  %81 = getelementptr inbounds %struct.pkt_meta, ptr %2, i64 0, i32 6, !dbg !406
  store i16 %80, ptr %81, align 2, !dbg !407, !tbaa !408
  %82 = zext i32 %78 to i64, !dbg !409
  %83 = sub nsw i64 %79, %82, !dbg !410
  %84 = trunc i64 %83 to i16, !dbg !411
  %85 = getelementptr inbounds %struct.pkt_meta, ptr %2, i64 0, i32 5, !dbg !412
  store i16 %84, ptr %85, align 4, !dbg !413, !tbaa !414
  %86 = shl i64 %79, 32, !dbg !415
  %87 = and i64 %86, 281470681743360, !dbg !415
  %88 = or i64 %87, 4294967295, !dbg !416
  %89 = call i64 inttoptr (i64 25 to ptr)(ptr noundef nonnull %0, ptr noundef nonnull @perf_map, i64 noundef %88, ptr noundef nonnull %2, i64 noundef 48) #6, !dbg !417
  br label %90, !dbg !418

90:                                               ; preds = %20, %17, %64, %51, %30, %44, %1, %77
  call void @llvm.lifetime.end.p0(i64 48, ptr nonnull %2) #6, !dbg !419
  ret i32 2, !dbg !419
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #2

; Function Attrs: argmemonly mustprogress nocallback nofree nounwind willreturn writeonly
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #3

; Function Attrs: mustprogress nocallback nofree nosync nounwind readnone speculatable willreturn
declare i16 @llvm.bswap.i16(i16) #1

; Function Attrs: argmemonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #2

; Function Attrs: argmemonly mustprogress nocallback nofree nounwind willreturn
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #4

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
!llvm.module.flags = !{!91, !92, !93, !94}
!llvm.ident = !{!95}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "perf_map", scope: !2, file: !63, line: 24, type: !74, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 15.0.7", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !52, globals: !60, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/benchmarks/xdpdump/prog.bpf.c", directory: "/run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/benchmarks/xdpdump", checksumkind: CSK_MD5, checksum: "9c6af86a08d2381883811ce3abb1aa37")
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
!14 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !15, line: 29, baseType: !7, size: 32, elements: !16)
!15 = !DIFile(filename: "/usr/include/linux/in.h", directory: "", checksumkind: CSK_MD5, checksum: "800947bc91ad5a693098cf2699931b1e")
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
!46 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 5796, baseType: !47, size: 64, elements: !48)
!47 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!48 = !{!49, !50, !51}
!49 = !DIEnumerator(name: "BPF_F_INDEX_MASK", value: 4294967295, isUnsigned: true)
!50 = !DIEnumerator(name: "BPF_F_CURRENT_CPU", value: 4294967295, isUnsigned: true)
!51 = !DIEnumerator(name: "BPF_F_CTXLEN_MASK", value: 4503595332403200, isUnsigned: true)
!52 = !{!53, !54, !55, !58}
!53 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!54 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!55 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !56, line: 24, baseType: !57)
!56 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!57 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!58 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !56, line: 31, baseType: !59)
!59 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!60 = !{!61, !0, !68}
!61 = !DIGlobalVariableExpression(var: !62, expr: !DIExpression())
!62 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !63, line: 179, type: !64, isLocal: false, isDefinition: true)
!63 = !DIFile(filename: "prog.bpf.c", directory: "/run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/benchmarks/xdpdump", checksumkind: CSK_MD5, checksum: "9c6af86a08d2381883811ce3abb1aa37")
!64 = !DICompositeType(tag: DW_TAG_array_type, baseType: !65, size: 104, elements: !66)
!65 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!66 = !{!67}
!67 = !DISubrange(count: 13)
!68 = !DIGlobalVariableExpression(var: !69, expr: !DIExpression())
!69 = distinct !DIGlobalVariable(name: "bpf_perf_event_output", scope: !2, file: !70, line: 696, type: !71, isLocal: true, isDefinition: true)
!70 = !DIFile(filename: "/usr/include/bpf/bpf_helper_defs.h", directory: "", checksumkind: CSK_MD5, checksum: "7422ca06c9dc86eba2f268a57d8acf2f")
!71 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !72, size: 64)
!72 = !DISubroutineType(types: !73)
!73 = !{!54, !53, !53, !58, !53, !58}
!74 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !63, line: 19, size: 256, elements: !75)
!75 = !{!76, !82, !87, !90}
!76 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !74, file: !63, line: 20, baseType: !77, size: 64)
!77 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !78, size: 64)
!78 = !DICompositeType(tag: DW_TAG_array_type, baseType: !79, size: 128, elements: !80)
!79 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!80 = !{!81}
!81 = !DISubrange(count: 4)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !74, file: !63, line: 21, baseType: !83, size: 64, offset: 64)
!83 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !84, size: 64)
!84 = !DICompositeType(tag: DW_TAG_array_type, baseType: !79, size: 4096, elements: !85)
!85 = !{!86}
!86 = !DISubrange(count: 128)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !74, file: !63, line: 22, baseType: !88, size: 64, offset: 128)
!88 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !89, size: 64)
!89 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !56, line: 27, baseType: !7)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !74, file: !63, line: 23, baseType: !88, size: 64, offset: 192)
!91 = !{i32 7, !"Dwarf Version", i32 5}
!92 = !{i32 2, !"Debug Info Version", i32 3}
!93 = !{i32 1, !"wchar_size", i32 4}
!94 = !{i32 7, !"frame-pointer", i32 2}
!95 = !{!"clang version 15.0.7"}
!96 = distinct !DISubprogram(name: "process_packet", scope: !63, file: !63, line: 119, type: !97, scopeLine: 120, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !108)
!97 = !DISubroutineType(types: !98)
!98 = !{!79, !99}
!99 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !100, size: 64)
!100 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 6141, size: 192, elements: !101)
!101 = !{!102, !103, !104, !105, !106, !107}
!102 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !100, file: !6, line: 6142, baseType: !89, size: 32)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !100, file: !6, line: 6143, baseType: !89, size: 32, offset: 32)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !100, file: !6, line: 6144, baseType: !89, size: 32, offset: 64)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !100, file: !6, line: 6146, baseType: !89, size: 32, offset: 96)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !100, file: !6, line: 6147, baseType: !89, size: 32, offset: 128)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "egress_ifindex", scope: !100, file: !6, line: 6149, baseType: !89, size: 32, offset: 160)
!108 = !{!109, !110, !111, !112, !126, !151}
!109 = !DILocalVariable(name: "ctx", arg: 1, scope: !96, file: !63, line: 119, type: !99)
!110 = !DILocalVariable(name: "data_end", scope: !96, file: !63, line: 121, type: !53)
!111 = !DILocalVariable(name: "data", scope: !96, file: !63, line: 122, type: !53)
!112 = !DILocalVariable(name: "eth", scope: !96, file: !63, line: 123, type: !113)
!113 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !114, size: 64)
!114 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !115, line: 173, size: 112, elements: !116)
!115 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "163f54fb1af2e21fea410f14eb18fa76")
!116 = !{!117, !122, !123}
!117 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !114, file: !115, line: 174, baseType: !118, size: 48)
!118 = !DICompositeType(tag: DW_TAG_array_type, baseType: !119, size: 48, elements: !120)
!119 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!120 = !{!121}
!121 = !DISubrange(count: 6)
!122 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !114, file: !115, line: 175, baseType: !118, size: 48, offset: 48)
!123 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !114, file: !115, line: 176, baseType: !124, size: 16, offset: 96)
!124 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !125, line: 28, baseType: !55)
!125 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "64bcf4b731906682de6e750679b9f4a2")
!126 = !DILocalVariable(name: "pkt", scope: !96, file: !63, line: 124, type: !127)
!127 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "pkt_meta", file: !128, line: 6, size: 384, elements: !129)
!128 = !DIFile(filename: "xdpdump_common.h", directory: "/run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/benchmarks/xdpdump", checksumkind: CSK_MD5, checksum: "1e3b032e06c84f4352d43473a143e904")
!129 = !{!130, !137, !142, !146, !147, !148, !149, !150}
!130 = !DIDerivedType(tag: DW_TAG_member, scope: !127, file: !128, line: 7, baseType: !131, size: 128)
!131 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !127, file: !128, line: 7, size: 128, elements: !132)
!132 = !{!133, !135}
!133 = !DIDerivedType(tag: DW_TAG_member, name: "src", scope: !131, file: !128, line: 8, baseType: !134, size: 32)
!134 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !125, line: 30, baseType: !89)
!135 = !DIDerivedType(tag: DW_TAG_member, name: "srcv6", scope: !131, file: !128, line: 9, baseType: !136, size: 128)
!136 = !DICompositeType(tag: DW_TAG_array_type, baseType: !134, size: 128, elements: !80)
!137 = !DIDerivedType(tag: DW_TAG_member, scope: !127, file: !128, line: 11, baseType: !138, size: 128, offset: 128)
!138 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !127, file: !128, line: 11, size: 128, elements: !139)
!139 = !{!140, !141}
!140 = !DIDerivedType(tag: DW_TAG_member, name: "dst", scope: !138, file: !128, line: 12, baseType: !134, size: 32)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "dstv6", scope: !138, file: !128, line: 13, baseType: !136, size: 128)
!142 = !DIDerivedType(tag: DW_TAG_member, name: "port16", scope: !127, file: !128, line: 15, baseType: !143, size: 32, offset: 256)
!143 = !DICompositeType(tag: DW_TAG_array_type, baseType: !55, size: 32, elements: !144)
!144 = !{!145}
!145 = !DISubrange(count: 2)
!146 = !DIDerivedType(tag: DW_TAG_member, name: "l3_proto", scope: !127, file: !128, line: 16, baseType: !55, size: 16, offset: 288)
!147 = !DIDerivedType(tag: DW_TAG_member, name: "l4_proto", scope: !127, file: !128, line: 17, baseType: !55, size: 16, offset: 304)
!148 = !DIDerivedType(tag: DW_TAG_member, name: "data_len", scope: !127, file: !128, line: 18, baseType: !55, size: 16, offset: 320)
!149 = !DIDerivedType(tag: DW_TAG_member, name: "pkt_len", scope: !127, file: !128, line: 19, baseType: !55, size: 16, offset: 336)
!150 = !DIDerivedType(tag: DW_TAG_member, name: "seq", scope: !127, file: !128, line: 20, baseType: !89, size: 32, offset: 352)
!151 = !DILocalVariable(name: "off", scope: !96, file: !63, line: 125, type: !89)
!152 = !DILocation(line: 0, scope: !96)
!153 = !DILocation(line: 121, column: 38, scope: !96)
!154 = !{!155, !156, i64 4}
!155 = !{!"xdp_md", !156, i64 0, !156, i64 4, !156, i64 8, !156, i64 12, !156, i64 16, !156, i64 20}
!156 = !{!"int", !157, i64 0}
!157 = !{!"omnipotent char", !158, i64 0}
!158 = !{!"Simple C/C++ TBAA"}
!159 = !DILocation(line: 121, column: 27, scope: !96)
!160 = !DILocation(line: 121, column: 19, scope: !96)
!161 = !DILocation(line: 122, column: 34, scope: !96)
!162 = !{!155, !156, i64 0}
!163 = !DILocation(line: 122, column: 23, scope: !96)
!164 = !DILocation(line: 122, column: 15, scope: !96)
!165 = !DILocation(line: 124, column: 2, scope: !96)
!166 = !DILocation(line: 124, column: 18, scope: !96)
!167 = !DILocation(line: 129, column: 11, scope: !168)
!168 = distinct !DILexicalBlock(scope: !96, file: !63, line: 129, column: 6)
!169 = !DILocation(line: 129, column: 17, scope: !168)
!170 = !DILocation(line: 129, column: 6, scope: !96)
!171 = !DILocation(line: 132, column: 17, scope: !96)
!172 = !{!173, !174, i64 12}
!173 = !{!"ethhdr", !157, i64 0, !157, i64 6, !174, i64 12}
!174 = !{!"short", !157, i64 0}
!175 = !DILocation(line: 132, column: 6, scope: !96)
!176 = !DILocation(line: 132, column: 15, scope: !96)
!177 = !{!178, !174, i64 36}
!178 = !{!"pkt_meta", !157, i64 0, !157, i64 16, !157, i64 32, !174, i64 36, !174, i64 38, !174, i64 40, !174, i64 42, !156, i64 44}
!179 = !DILocation(line: 135, column: 6, scope: !96)
!180 = !DILocalVariable(name: "data", arg: 1, scope: !181, file: !63, line: 76, type: !53)
!181 = distinct !DISubprogram(name: "parse_ip4", scope: !63, file: !63, line: 76, type: !182, scopeLine: 76, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !186)
!182 = !DISubroutineType(cc: DW_CC_nocall, types: !183)
!183 = !{!184, !53, !58, !53, !185}
!184 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!185 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !127, size: 64)
!186 = !{!180, !187, !188, !189, !190}
!187 = !DILocalVariable(name: "off", arg: 2, scope: !181, file: !63, line: 76, type: !58)
!188 = !DILocalVariable(name: "data_end", arg: 3, scope: !181, file: !63, line: 76, type: !53)
!189 = !DILocalVariable(name: "pkt", arg: 4, scope: !181, file: !63, line: 76, type: !185)
!190 = !DILocalVariable(name: "iph", scope: !181, file: !63, line: 77, type: !191)
!191 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !192, size: 64)
!192 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !193, line: 87, size: 160, elements: !194)
!193 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "", checksumkind: CSK_MD5, checksum: "149778ace30a1ff208adc8783fd04b29")
!194 = !{!195, !197, !198, !199, !200, !201, !202, !203, !204, !206}
!195 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !192, file: !193, line: 89, baseType: !196, size: 4, flags: DIFlagBitField, extraData: i64 0)
!196 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !56, line: 21, baseType: !119)
!197 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !192, file: !193, line: 90, baseType: !196, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!198 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !192, file: !193, line: 97, baseType: !196, size: 8, offset: 8)
!199 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !192, file: !193, line: 98, baseType: !124, size: 16, offset: 16)
!200 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !192, file: !193, line: 99, baseType: !124, size: 16, offset: 32)
!201 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !192, file: !193, line: 100, baseType: !124, size: 16, offset: 48)
!202 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !192, file: !193, line: 101, baseType: !196, size: 8, offset: 64)
!203 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !192, file: !193, line: 102, baseType: !196, size: 8, offset: 72)
!204 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !192, file: !193, line: 103, baseType: !205, size: 16, offset: 80)
!205 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !125, line: 34, baseType: !55)
!206 = !DIDerivedType(tag: DW_TAG_member, scope: !192, file: !193, line: 104, baseType: !207, size: 64, offset: 96)
!207 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !192, file: !193, line: 104, size: 64, elements: !208)
!208 = !{!209, !214}
!209 = !DIDerivedType(tag: DW_TAG_member, scope: !207, file: !193, line: 104, baseType: !210, size: 64)
!210 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !207, file: !193, line: 104, size: 64, elements: !211)
!211 = !{!212, !213}
!212 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !210, file: !193, line: 104, baseType: !134, size: 32)
!213 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !210, file: !193, line: 104, baseType: !134, size: 32, offset: 32)
!214 = !DIDerivedType(tag: DW_TAG_member, name: "addrs", scope: !207, file: !193, line: 104, baseType: !215, size: 64)
!215 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !207, file: !193, line: 104, size: 64, elements: !216)
!216 = !{!217, !218}
!217 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !215, file: !193, line: 104, baseType: !134, size: 32)
!218 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !215, file: !193, line: 104, baseType: !134, size: 32, offset: 32)
!219 = !DILocation(line: 0, scope: !181, inlinedAt: !220)
!220 = distinct !DILocation(line: 137, column: 8, scope: !221)
!221 = distinct !DILexicalBlock(scope: !222, file: !63, line: 137, column: 7)
!222 = distinct !DILexicalBlock(scope: !223, file: !63, line: 136, column: 2)
!223 = distinct !DILexicalBlock(scope: !96, file: !63, line: 135, column: 6)
!224 = !DILocation(line: 80, column: 17, scope: !225, inlinedAt: !220)
!225 = distinct !DILexicalBlock(scope: !181, file: !63, line: 80, column: 6)
!226 = !DILocation(line: 80, column: 40, scope: !225, inlinedAt: !220)
!227 = !DILocation(line: 80, column: 6, scope: !181, inlinedAt: !220)
!228 = !DILocation(line: 83, column: 11, scope: !229, inlinedAt: !220)
!229 = distinct !DILexicalBlock(scope: !181, file: !63, line: 83, column: 6)
!230 = !DILocation(line: 83, column: 15, scope: !229, inlinedAt: !220)
!231 = !DILocation(line: 83, column: 6, scope: !181, inlinedAt: !220)
!232 = !DILocation(line: 86, column: 18, scope: !181, inlinedAt: !220)
!233 = !{!157, !157, i64 0}
!234 = !DILocation(line: 86, column: 11, scope: !181, inlinedAt: !220)
!235 = !DILocation(line: 87, column: 18, scope: !181, inlinedAt: !220)
!236 = !DILocation(line: 87, column: 7, scope: !181, inlinedAt: !220)
!237 = !DILocation(line: 87, column: 11, scope: !181, inlinedAt: !220)
!238 = !DILocation(line: 137, column: 7, scope: !222)
!239 = !DILocalVariable(name: "data", arg: 1, scope: !240, file: !63, line: 101, type: !53)
!240 = distinct !DISubprogram(name: "parse_ip6", scope: !63, file: !63, line: 101, type: !182, scopeLine: 101, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !241)
!241 = !{!239, !242, !243, !244, !245}
!242 = !DILocalVariable(name: "off", arg: 2, scope: !240, file: !63, line: 101, type: !58)
!243 = !DILocalVariable(name: "data_end", arg: 3, scope: !240, file: !63, line: 101, type: !53)
!244 = !DILocalVariable(name: "pkt", arg: 4, scope: !240, file: !63, line: 101, type: !185)
!245 = !DILocalVariable(name: "ip6h", scope: !240, file: !63, line: 102, type: !246)
!246 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !247, size: 64)
!247 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ipv6hdr", file: !248, line: 118, size: 320, elements: !249)
!248 = !DIFile(filename: "/usr/include/linux/ipv6.h", directory: "", checksumkind: CSK_MD5, checksum: "deff6bca6b519042089ed906aa3655c3")
!249 = !{!250, !251, !252, !256, !257, !258, !259}
!250 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !247, file: !248, line: 120, baseType: !196, size: 4, flags: DIFlagBitField, extraData: i64 0)
!251 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !247, file: !248, line: 121, baseType: !196, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!252 = !DIDerivedType(tag: DW_TAG_member, name: "flow_lbl", scope: !247, file: !248, line: 128, baseType: !253, size: 24, offset: 8)
!253 = !DICompositeType(tag: DW_TAG_array_type, baseType: !196, size: 24, elements: !254)
!254 = !{!255}
!255 = !DISubrange(count: 3)
!256 = !DIDerivedType(tag: DW_TAG_member, name: "payload_len", scope: !247, file: !248, line: 130, baseType: !124, size: 16, offset: 32)
!257 = !DIDerivedType(tag: DW_TAG_member, name: "nexthdr", scope: !247, file: !248, line: 131, baseType: !196, size: 8, offset: 48)
!258 = !DIDerivedType(tag: DW_TAG_member, name: "hop_limit", scope: !247, file: !248, line: 132, baseType: !196, size: 8, offset: 56)
!259 = !DIDerivedType(tag: DW_TAG_member, scope: !247, file: !248, line: 134, baseType: !260, size: 256, offset: 64)
!260 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !247, file: !248, line: 134, size: 256, elements: !261)
!261 = !{!262, !282}
!262 = !DIDerivedType(tag: DW_TAG_member, scope: !260, file: !248, line: 134, baseType: !263, size: 256)
!263 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !260, file: !248, line: 134, size: 256, elements: !264)
!264 = !{!265, !281}
!265 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !263, file: !248, line: 134, baseType: !266, size: 128)
!266 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "in6_addr", file: !267, line: 33, size: 128, elements: !268)
!267 = !DIFile(filename: "/usr/include/linux/in6.h", directory: "", checksumkind: CSK_MD5, checksum: "8bebb780b45d3fe932cc1d934fa5f5fe")
!268 = !{!269}
!269 = !DIDerivedType(tag: DW_TAG_member, name: "in6_u", scope: !266, file: !267, line: 40, baseType: !270, size: 128)
!270 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !266, file: !267, line: 34, size: 128, elements: !271)
!271 = !{!272, !276, !280}
!272 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr8", scope: !270, file: !267, line: 35, baseType: !273, size: 128)
!273 = !DICompositeType(tag: DW_TAG_array_type, baseType: !196, size: 128, elements: !274)
!274 = !{!275}
!275 = !DISubrange(count: 16)
!276 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr16", scope: !270, file: !267, line: 37, baseType: !277, size: 128)
!277 = !DICompositeType(tag: DW_TAG_array_type, baseType: !124, size: 128, elements: !278)
!278 = !{!279}
!279 = !DISubrange(count: 8)
!280 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr32", scope: !270, file: !267, line: 38, baseType: !136, size: 128)
!281 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !263, file: !248, line: 134, baseType: !266, size: 128, offset: 128)
!282 = !DIDerivedType(tag: DW_TAG_member, name: "addrs", scope: !260, file: !248, line: 134, baseType: !283, size: 256)
!283 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !260, file: !248, line: 134, size: 256, elements: !284)
!284 = !{!285, !286}
!285 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !283, file: !248, line: 134, baseType: !266, size: 128)
!286 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !283, file: !248, line: 134, baseType: !266, size: 128, offset: 128)
!287 = !DILocation(line: 0, scope: !240, inlinedAt: !288)
!288 = distinct !DILocation(line: 143, column: 8, scope: !289)
!289 = distinct !DILexicalBlock(scope: !290, file: !63, line: 143, column: 7)
!290 = distinct !DILexicalBlock(scope: !291, file: !63, line: 142, column: 2)
!291 = distinct !DILexicalBlock(scope: !223, file: !63, line: 141, column: 11)
!292 = !DILocation(line: 105, column: 17, scope: !293, inlinedAt: !288)
!293 = distinct !DILexicalBlock(scope: !240, file: !63, line: 105, column: 6)
!294 = !DILocation(line: 105, column: 42, scope: !293, inlinedAt: !288)
!295 = !DILocation(line: 105, column: 6, scope: !240, inlinedAt: !288)
!296 = !DILocation(line: 108, column: 27, scope: !240, inlinedAt: !288)
!297 = !DILocation(line: 108, column: 2, scope: !240, inlinedAt: !288)
!298 = !DILocation(line: 109, column: 14, scope: !240, inlinedAt: !288)
!299 = !DILocation(line: 109, column: 27, scope: !240, inlinedAt: !288)
!300 = !DILocation(line: 109, column: 2, scope: !240, inlinedAt: !288)
!301 = !DILocation(line: 143, column: 7, scope: !290)
!302 = !DILocation(line: 0, scope: !223)
!303 = !{!178, !174, i64 38}
!304 = !DILocation(line: 148, column: 11, scope: !305)
!305 = distinct !DILexicalBlock(scope: !96, file: !63, line: 148, column: 6)
!306 = !DILocation(line: 148, column: 17, scope: !305)
!307 = !DILocation(line: 148, column: 6, scope: !96)
!308 = !DILocation(line: 152, column: 6, scope: !96)
!309 = !DILocalVariable(name: "data", arg: 1, scope: !310, file: !63, line: 54, type: !53)
!310 = distinct !DISubprogram(name: "parse_tcp", scope: !63, file: !63, line: 54, type: !311, scopeLine: 54, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !312)
!311 = !DISubroutineType(types: !183)
!312 = !{!309, !313, !314, !315, !316}
!313 = !DILocalVariable(name: "off", arg: 2, scope: !310, file: !63, line: 54, type: !58)
!314 = !DILocalVariable(name: "data_end", arg: 3, scope: !310, file: !63, line: 54, type: !53)
!315 = !DILocalVariable(name: "pkt", arg: 4, scope: !310, file: !63, line: 54, type: !185)
!316 = !DILocalVariable(name: "tcp", scope: !310, file: !63, line: 55, type: !317)
!317 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !318, size: 64)
!318 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "tcphdr", file: !319, line: 25, size: 160, elements: !320)
!319 = !DIFile(filename: "/usr/include/linux/tcp.h", directory: "", checksumkind: CSK_MD5, checksum: "0fb7164446a017a2406c1e3b94b6d7a6")
!320 = !{!321, !322, !323, !324, !325, !326, !327, !328, !329, !330, !331, !332, !333, !334, !335, !336, !337}
!321 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !318, file: !319, line: 26, baseType: !124, size: 16)
!322 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !318, file: !319, line: 27, baseType: !124, size: 16, offset: 16)
!323 = !DIDerivedType(tag: DW_TAG_member, name: "seq", scope: !318, file: !319, line: 28, baseType: !134, size: 32, offset: 32)
!324 = !DIDerivedType(tag: DW_TAG_member, name: "ack_seq", scope: !318, file: !319, line: 29, baseType: !134, size: 32, offset: 64)
!325 = !DIDerivedType(tag: DW_TAG_member, name: "res1", scope: !318, file: !319, line: 31, baseType: !55, size: 4, offset: 96, flags: DIFlagBitField, extraData: i64 96)
!326 = !DIDerivedType(tag: DW_TAG_member, name: "doff", scope: !318, file: !319, line: 32, baseType: !55, size: 4, offset: 100, flags: DIFlagBitField, extraData: i64 96)
!327 = !DIDerivedType(tag: DW_TAG_member, name: "fin", scope: !318, file: !319, line: 33, baseType: !55, size: 1, offset: 104, flags: DIFlagBitField, extraData: i64 96)
!328 = !DIDerivedType(tag: DW_TAG_member, name: "syn", scope: !318, file: !319, line: 34, baseType: !55, size: 1, offset: 105, flags: DIFlagBitField, extraData: i64 96)
!329 = !DIDerivedType(tag: DW_TAG_member, name: "rst", scope: !318, file: !319, line: 35, baseType: !55, size: 1, offset: 106, flags: DIFlagBitField, extraData: i64 96)
!330 = !DIDerivedType(tag: DW_TAG_member, name: "psh", scope: !318, file: !319, line: 36, baseType: !55, size: 1, offset: 107, flags: DIFlagBitField, extraData: i64 96)
!331 = !DIDerivedType(tag: DW_TAG_member, name: "ack", scope: !318, file: !319, line: 37, baseType: !55, size: 1, offset: 108, flags: DIFlagBitField, extraData: i64 96)
!332 = !DIDerivedType(tag: DW_TAG_member, name: "urg", scope: !318, file: !319, line: 38, baseType: !55, size: 1, offset: 109, flags: DIFlagBitField, extraData: i64 96)
!333 = !DIDerivedType(tag: DW_TAG_member, name: "ece", scope: !318, file: !319, line: 39, baseType: !55, size: 1, offset: 110, flags: DIFlagBitField, extraData: i64 96)
!334 = !DIDerivedType(tag: DW_TAG_member, name: "cwr", scope: !318, file: !319, line: 40, baseType: !55, size: 1, offset: 111, flags: DIFlagBitField, extraData: i64 96)
!335 = !DIDerivedType(tag: DW_TAG_member, name: "window", scope: !318, file: !319, line: 55, baseType: !124, size: 16, offset: 112)
!336 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !318, file: !319, line: 56, baseType: !205, size: 16, offset: 128)
!337 = !DIDerivedType(tag: DW_TAG_member, name: "urg_ptr", scope: !318, file: !319, line: 57, baseType: !124, size: 16, offset: 144)
!338 = !DILocation(line: 0, scope: !310, inlinedAt: !339)
!339 = distinct !DILocation(line: 154, column: 8, scope: !340)
!340 = distinct !DILexicalBlock(scope: !341, file: !63, line: 154, column: 7)
!341 = distinct !DILexicalBlock(scope: !342, file: !63, line: 153, column: 2)
!342 = distinct !DILexicalBlock(scope: !96, file: !63, line: 152, column: 6)
!343 = !DILocation(line: 58, column: 17, scope: !344, inlinedAt: !339)
!344 = distinct !DILexicalBlock(scope: !310, file: !63, line: 58, column: 6)
!345 = !DILocation(line: 58, column: 41, scope: !344, inlinedAt: !339)
!346 = !DILocation(line: 58, column: 6, scope: !310, inlinedAt: !339)
!347 = !DILocation(line: 61, column: 24, scope: !310, inlinedAt: !339)
!348 = !{!349, !174, i64 0}
!349 = !{!"tcphdr", !174, i64 0, !174, i64 2, !156, i64 4, !156, i64 8, !174, i64 12, !174, i64 12, !174, i64 13, !174, i64 13, !174, i64 13, !174, i64 13, !174, i64 13, !174, i64 13, !174, i64 13, !174, i64 13, !174, i64 14, !174, i64 16, !174, i64 18}
!350 = !DILocation(line: 61, column: 7, scope: !310, inlinedAt: !339)
!351 = !DILocation(line: 61, column: 17, scope: !310, inlinedAt: !339)
!352 = !{!174, !174, i64 0}
!353 = !DILocation(line: 62, column: 24, scope: !310, inlinedAt: !339)
!354 = !{!349, !174, i64 2}
!355 = !DILocation(line: 62, column: 2, scope: !310, inlinedAt: !339)
!356 = !DILocation(line: 62, column: 17, scope: !310, inlinedAt: !339)
!357 = !DILocation(line: 63, column: 18, scope: !310, inlinedAt: !339)
!358 = !{!349, !156, i64 4}
!359 = !DILocation(line: 63, column: 7, scope: !310, inlinedAt: !339)
!360 = !DILocation(line: 63, column: 11, scope: !310, inlinedAt: !339)
!361 = !{!178, !156, i64 44}
!362 = !DILocation(line: 156, column: 7, scope: !341)
!363 = !DILocation(line: 157, column: 2, scope: !341)
!364 = !DILocalVariable(name: "data", arg: 1, scope: !365, file: !63, line: 34, type: !53)
!365 = distinct !DISubprogram(name: "parse_udp", scope: !63, file: !63, line: 34, type: !311, scopeLine: 34, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !366)
!366 = !{!364, !367, !368, !369, !370}
!367 = !DILocalVariable(name: "off", arg: 2, scope: !365, file: !63, line: 34, type: !58)
!368 = !DILocalVariable(name: "data_end", arg: 3, scope: !365, file: !63, line: 34, type: !53)
!369 = !DILocalVariable(name: "pkt", arg: 4, scope: !365, file: !63, line: 34, type: !185)
!370 = !DILocalVariable(name: "udp", scope: !365, file: !63, line: 35, type: !371)
!371 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !372, size: 64)
!372 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "udphdr", file: !373, line: 23, size: 64, elements: !374)
!373 = !DIFile(filename: "/usr/include/linux/udp.h", directory: "", checksumkind: CSK_MD5, checksum: "53c0d42e1bf6d93b39151764be2d20fb")
!374 = !{!375, !376, !377, !378}
!375 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !372, file: !373, line: 24, baseType: !124, size: 16)
!376 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !372, file: !373, line: 25, baseType: !124, size: 16, offset: 16)
!377 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !372, file: !373, line: 26, baseType: !124, size: 16, offset: 32)
!378 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !372, file: !373, line: 27, baseType: !205, size: 16, offset: 48)
!379 = !DILocation(line: 0, scope: !365, inlinedAt: !380)
!380 = distinct !DILocation(line: 160, column: 8, scope: !381)
!381 = distinct !DILexicalBlock(scope: !382, file: !63, line: 160, column: 7)
!382 = distinct !DILexicalBlock(scope: !383, file: !63, line: 159, column: 2)
!383 = distinct !DILexicalBlock(scope: !342, file: !63, line: 158, column: 11)
!384 = !DILocation(line: 38, column: 17, scope: !385, inlinedAt: !380)
!385 = distinct !DILexicalBlock(scope: !365, file: !63, line: 38, column: 6)
!386 = !DILocation(line: 38, column: 41, scope: !385, inlinedAt: !380)
!387 = !DILocation(line: 38, column: 6, scope: !365, inlinedAt: !380)
!388 = !DILocation(line: 41, column: 24, scope: !365, inlinedAt: !380)
!389 = !{!390, !174, i64 0}
!390 = !{!"udphdr", !174, i64 0, !174, i64 2, !174, i64 4, !174, i64 6}
!391 = !DILocation(line: 41, column: 7, scope: !365, inlinedAt: !380)
!392 = !DILocation(line: 41, column: 17, scope: !365, inlinedAt: !380)
!393 = !DILocation(line: 42, column: 24, scope: !365, inlinedAt: !380)
!394 = !{!390, !174, i64 2}
!395 = !DILocation(line: 42, column: 2, scope: !365, inlinedAt: !380)
!396 = !DILocation(line: 42, column: 17, scope: !365, inlinedAt: !380)
!397 = !DILocation(line: 162, column: 7, scope: !382)
!398 = !DILocation(line: 163, column: 2, scope: !382)
!399 = !DILocation(line: 166, column: 7, scope: !400)
!400 = distinct !DILexicalBlock(scope: !383, file: !63, line: 165, column: 2)
!401 = !DILocation(line: 166, column: 17, scope: !400)
!402 = !DILocation(line: 167, column: 3, scope: !400)
!403 = !DILocation(line: 167, column: 17, scope: !400)
!404 = !DILocation(line: 170, column: 25, scope: !96)
!405 = !DILocation(line: 170, column: 16, scope: !96)
!406 = !DILocation(line: 170, column: 6, scope: !96)
!407 = !DILocation(line: 170, column: 14, scope: !96)
!408 = !{!178, !174, i64 42}
!409 = !DILocation(line: 171, column: 35, scope: !96)
!410 = !DILocation(line: 171, column: 33, scope: !96)
!411 = !DILocation(line: 171, column: 17, scope: !96)
!412 = !DILocation(line: 171, column: 6, scope: !96)
!413 = !DILocation(line: 171, column: 15, scope: !96)
!414 = !{!178, !174, i64 40}
!415 = !DILocation(line: 174, column: 28, scope: !96)
!416 = !DILocation(line: 174, column: 34, scope: !96)
!417 = !DILocation(line: 173, column: 2, scope: !96)
!418 = !DILocation(line: 176, column: 2, scope: !96)
!419 = !DILocation(line: 177, column: 1, scope: !96)
