; ModuleID = 'prog.bpf.c'
source_filename = "prog.bpf.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.anon = type { ptr, ptr, ptr, ptr }
%struct.xdp_md = type { i32, i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.udphdr = type { i16, i16, i16, i16 }

@map = dso_local global %struct.anon zeroinitializer, section ".maps", align 8, !dbg !0
@_license = dso_local global [13 x i8] c"Dual BSD/GPL\00", section "license", align 1, !dbg !56
@llvm.compiler.used = appending global [3 x ptr] [ptr @_license, ptr @dropXDP, ptr @map], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @dropXDP(ptr nocapture noundef readonly %0) #0 section "xdp_drop_UDP" !dbg !94 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata ptr %0, metadata !107, metadata !DIExpression()), !dbg !135
  %3 = getelementptr inbounds %struct.xdp_md, ptr %0, i64 0, i32 1, !dbg !136
  %4 = load i32, ptr %3, align 4, !dbg !136, !tbaa !137
  %5 = zext i32 %4 to i64, !dbg !142
  %6 = inttoptr i64 %5 to ptr, !dbg !143
  call void @llvm.dbg.value(metadata ptr %6, metadata !108, metadata !DIExpression()), !dbg !135
  %7 = load i32, ptr %0, align 4, !dbg !144, !tbaa !145
  %8 = zext i32 %7 to i64, !dbg !146
  %9 = inttoptr i64 %8 to ptr, !dbg !147
  call void @llvm.dbg.value(metadata ptr %9, metadata !109, metadata !DIExpression()), !dbg !135
  call void @llvm.dbg.value(metadata ptr %9, metadata !110, metadata !DIExpression()), !dbg !135
  call void @llvm.dbg.value(metadata i64 14, metadata !123, metadata !DIExpression()), !dbg !135
  call void @llvm.dbg.value(metadata i32 0, metadata !126, metadata !DIExpression()), !dbg !135
  %10 = getelementptr i8, ptr %9, i64 14, !dbg !148
  %11 = icmp ugt ptr %10, %6, !dbg !150
  br i1 %11, label %47, label %12, !dbg !151

12:                                               ; preds = %1
  %13 = getelementptr inbounds %struct.ethhdr, ptr %9, i64 0, i32 2, !dbg !152
  %14 = load i16, ptr %13, align 1, !dbg !152, !tbaa !154
  switch i16 %14, label %47 [
    i16 8, label %15
    i16 -8826, label %18
  ], !dbg !157

15:                                               ; preds = %12
  call void @llvm.dbg.value(metadata ptr %9, metadata !158, metadata !DIExpression()), !dbg !184
  call void @llvm.dbg.value(metadata ptr undef, metadata !164, metadata !DIExpression()), !dbg !184
  call void @llvm.dbg.value(metadata ptr %6, metadata !165, metadata !DIExpression()), !dbg !184
  call void @llvm.dbg.value(metadata ptr %10, metadata !166, metadata !DIExpression()), !dbg !184
  %16 = getelementptr i8, ptr %9, i64 34, !dbg !186
  %17 = icmp ugt ptr %16, %6, !dbg !188
  br i1 %17, label %47, label %21, !dbg !189

18:                                               ; preds = %12
  call void @llvm.dbg.value(metadata ptr %9, metadata !190, metadata !DIExpression()), !dbg !242
  call void @llvm.dbg.value(metadata ptr undef, metadata !193, metadata !DIExpression()), !dbg !242
  call void @llvm.dbg.value(metadata ptr %6, metadata !194, metadata !DIExpression()), !dbg !242
  call void @llvm.dbg.value(metadata ptr %10, metadata !195, metadata !DIExpression()), !dbg !242
  %19 = getelementptr i8, ptr %9, i64 54, !dbg !245
  %20 = icmp ugt ptr %19, %6, !dbg !247
  br i1 %20, label %47, label %21, !dbg !248

21:                                               ; preds = %18, %15
  %22 = phi i64 [ 23, %15 ], [ 20, %18 ]
  %23 = phi i64 [ 34, %15 ], [ 54, %18 ], !dbg !249
  %24 = getelementptr i8, ptr %9, i64 %22, !dbg !250
  %25 = load i8, ptr %24, align 1, !dbg !250, !tbaa !251
  call void @llvm.dbg.value(metadata i8 %25, metadata !126, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !135
  %26 = icmp eq i8 %25, 17, !dbg !252
  br i1 %26, label %27, label %47, !dbg !253

27:                                               ; preds = %21
  call void @llvm.dbg.value(metadata i64 %23, metadata !123, metadata !DIExpression()), !dbg !135
  call void @llvm.dbg.value(metadata ptr %9, metadata !254, metadata !DIExpression()), !dbg !271
  call void @llvm.dbg.value(metadata i64 %23, metadata !259, metadata !DIExpression()), !dbg !271
  call void @llvm.dbg.value(metadata ptr %6, metadata !260, metadata !DIExpression()), !dbg !271
  %28 = getelementptr i8, ptr %9, i64 %23, !dbg !273
  call void @llvm.dbg.value(metadata ptr %28, metadata !261, metadata !DIExpression()), !dbg !271
  %29 = getelementptr i8, ptr %28, i64 8, !dbg !274
  %30 = icmp ugt ptr %29, %6, !dbg !276
  br i1 %30, label %34, label %31, !dbg !277

31:                                               ; preds = %27
  %32 = getelementptr inbounds %struct.udphdr, ptr %28, i64 0, i32 1, !dbg !278
  %33 = load i16, ptr %32, align 2, !dbg !278, !tbaa !279
  br label %34, !dbg !281

34:                                               ; preds = %27, %31
  %35 = phi i16 [ %33, %31 ], [ 0, %27 ]
  %36 = tail call i16 @llvm.bswap.i16(i16 %35)
  call void @llvm.dbg.value(metadata i16 %36, metadata !127, metadata !DIExpression()), !dbg !282
  switch i16 %36, label %47 [
    i16 3000, label %37
    i16 3001, label %43
  ], !dbg !283

37:                                               ; preds = %34
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #3, !dbg !284
  call void @llvm.dbg.value(metadata i32 3000, metadata !131, metadata !DIExpression()), !dbg !285
  store i32 3000, ptr %2, align 4, !dbg !286, !tbaa !287
  call void @llvm.dbg.value(metadata ptr %2, metadata !131, metadata !DIExpression(DW_OP_deref)), !dbg !285
  %38 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @map, ptr noundef nonnull %2) #3, !dbg !288
  call void @llvm.dbg.value(metadata ptr %38, metadata !134, metadata !DIExpression()), !dbg !285
  %39 = icmp eq ptr %38, null, !dbg !289
  br i1 %39, label %46, label %40, !dbg !291

40:                                               ; preds = %37
  %41 = load i64, ptr %38, align 8, !dbg !292, !tbaa !293
  %42 = add nsw i64 %41, 1, !dbg !292
  store i64 %42, ptr %38, align 8, !dbg !292, !tbaa !293
  br label %46, !dbg !295

43:                                               ; preds = %34
  call void @llvm.dbg.value(metadata i64 %23, metadata !123, metadata !DIExpression()), !dbg !135
  call void @llvm.dbg.value(metadata ptr %9, metadata !296, metadata !DIExpression()), !dbg !305
  call void @llvm.dbg.value(metadata i64 %23, metadata !301, metadata !DIExpression()), !dbg !305
  call void @llvm.dbg.value(metadata ptr %6, metadata !302, metadata !DIExpression()), !dbg !305
  call void @llvm.dbg.value(metadata i32 3000, metadata !303, metadata !DIExpression()), !dbg !305
  call void @llvm.dbg.value(metadata ptr %28, metadata !304, metadata !DIExpression()), !dbg !305
  br i1 %30, label %47, label %44, !dbg !309

44:                                               ; preds = %43
  %45 = getelementptr inbounds %struct.udphdr, ptr %28, i64 0, i32 1, !dbg !310
  store i16 -18421, ptr %45, align 2, !dbg !312, !tbaa !279
  br label %47, !dbg !313

46:                                               ; preds = %37, %40
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #3, !dbg !314
  br label %47

47:                                               ; preds = %34, %12, %43, %44, %18, %15, %21, %46, %1
  %48 = phi i32 [ 1, %46 ], [ 0, %1 ], [ 2, %21 ], [ 2, %15 ], [ 2, %18 ], [ 2, %44 ], [ 2, %43 ], [ 2, %12 ], [ 2, %34 ], !dbg !135
  ret i32 %48, !dbg !315
}

; Function Attrs: argmemonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: argmemonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i16 @llvm.bswap.i16(i16) #2

attributes #0 = { nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { argmemonly mustprogress nocallback nofree nosync nounwind willreturn }
attributes #2 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!89, !90, !91, !92}
!llvm.ident = !{!93}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "map", scope: !2, file: !3, line: 13, type: !70, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 15.0.7", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !46, globals: !55, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "prog.bpf.c", directory: "/run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/benchmarks/programs/dropudp", checksumkind: CSK_MD5, checksum: "9c9dc3dbd3ea872b1f81f2027eb2b0c2")
!4 = !{!5, !14}
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
!46 = !{!47, !48, !49, !53}
!47 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!48 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !50, line: 26, baseType: !51)
!50 = !DIFile(filename: "/usr/include/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "4ecee94d7257cd86659727d06a979b60")
!51 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !52, line: 42, baseType: !7)
!52 = !DIFile(filename: "/usr/include/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "4a64d909bcfa62a0a7682c3ac78c6965")
!53 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !52, line: 40, baseType: !54)
!54 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!55 = !{!56, !0, !62}
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 132, type: !58, isLocal: false, isDefinition: true)
!58 = !DICompositeType(tag: DW_TAG_array_type, baseType: !59, size: 104, elements: !60)
!59 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!60 = !{!61}
!61 = !DISubrange(count: 13)
!62 = !DIGlobalVariableExpression(var: !63, expr: !DIExpression())
!63 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !64, line: 51, type: !65, isLocal: true, isDefinition: true)
!64 = !DIFile(filename: "../../libs/libbpf/src/root/usr/include/bpf/bpf_helper_defs.h", directory: "/run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/benchmarks/programs/dropudp", checksumkind: CSK_MD5, checksum: "ad8ff3755106b533b446159c410c596d")
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !66, size: 64)
!66 = !DISubroutineType(types: !67)
!67 = !{!47, !47, !68}
!68 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !69, size: 64)
!69 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!70 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 8, size: 256, elements: !71)
!71 = !{!72, !78, !83, !85}
!72 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !70, file: !3, line: 9, baseType: !73, size: 64)
!73 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !74, size: 64)
!74 = !DICompositeType(tag: DW_TAG_array_type, baseType: !75, size: 192, elements: !76)
!75 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!76 = !{!77}
!77 = !DISubrange(count: 6)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !70, file: !3, line: 10, baseType: !79, size: 64, offset: 64)
!79 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !80, size: 64)
!80 = !DICompositeType(tag: DW_TAG_array_type, baseType: !75, size: 32, elements: !81)
!81 = !{!82}
!82 = !DISubrange(count: 1)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !70, file: !3, line: 11, baseType: !84, size: 64, offset: 128)
!84 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !48, size: 64)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !70, file: !3, line: 12, baseType: !86, size: 64, offset: 192)
!86 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !87, size: 64)
!87 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !88, line: 27, baseType: !7)
!88 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!89 = !{i32 7, !"Dwarf Version", i32 5}
!90 = !{i32 2, !"Debug Info Version", i32 3}
!91 = !{i32 1, !"wchar_size", i32 4}
!92 = !{i32 7, !"frame-pointer", i32 2}
!93 = !{!"clang version 15.0.7"}
!94 = distinct !DISubprogram(name: "dropXDP", scope: !3, file: !3, line: 94, type: !95, scopeLine: 94, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !106)
!95 = !DISubroutineType(types: !96)
!96 = !{!75, !97}
!97 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !98, size: 64)
!98 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 6141, size: 192, elements: !99)
!99 = !{!100, !101, !102, !103, !104, !105}
!100 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !98, file: !6, line: 6142, baseType: !87, size: 32)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !98, file: !6, line: 6143, baseType: !87, size: 32, offset: 32)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !98, file: !6, line: 6144, baseType: !87, size: 32, offset: 64)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !98, file: !6, line: 6146, baseType: !87, size: 32, offset: 96)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !98, file: !6, line: 6147, baseType: !87, size: 32, offset: 128)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "egress_ifindex", scope: !98, file: !6, line: 6149, baseType: !87, size: 32, offset: 160)
!106 = !{!107, !108, !109, !110, !123, !126, !127, !131, !134}
!107 = !DILocalVariable(name: "ctx", arg: 1, scope: !94, file: !3, line: 94, type: !97)
!108 = !DILocalVariable(name: "data_end", scope: !94, file: !3, line: 95, type: !47)
!109 = !DILocalVariable(name: "data", scope: !94, file: !3, line: 96, type: !47)
!110 = !DILocalVariable(name: "eth", scope: !94, file: !3, line: 97, type: !111)
!111 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !112, size: 64)
!112 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !113, line: 173, size: 112, elements: !114)
!113 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "163f54fb1af2e21fea410f14eb18fa76")
!114 = !{!115, !118, !119}
!115 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !112, file: !113, line: 174, baseType: !116, size: 48)
!116 = !DICompositeType(tag: DW_TAG_array_type, baseType: !117, size: 48, elements: !76)
!117 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!118 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !112, file: !113, line: 175, baseType: !116, size: 48, offset: 48)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !112, file: !113, line: 176, baseType: !120, size: 16, offset: 96)
!120 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !121, line: 28, baseType: !122)
!121 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "64bcf4b731906682de6e750679b9f4a2")
!122 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !88, line: 24, baseType: !54)
!123 = !DILocalVariable(name: "nh_off", scope: !94, file: !3, line: 99, type: !124)
!124 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !88, line: 31, baseType: !125)
!125 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!126 = !DILocalVariable(name: "ipproto", scope: !94, file: !3, line: 100, type: !87)
!127 = !DILocalVariable(name: "dest_port", scope: !128, file: !3, line: 114, type: !130)
!128 = distinct !DILexicalBlock(scope: !129, file: !3, line: 113, column: 33)
!129 = distinct !DILexicalBlock(scope: !94, file: !3, line: 113, column: 9)
!130 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !50, line: 25, baseType: !53)
!131 = !DILocalVariable(name: "index", scope: !132, file: !3, line: 117, type: !49)
!132 = distinct !DILexicalBlock(scope: !133, file: !3, line: 116, column: 32)
!133 = distinct !DILexicalBlock(scope: !128, file: !3, line: 116, column: 13)
!134 = !DILocalVariable(name: "value", scope: !132, file: !3, line: 118, type: !84)
!135 = !DILocation(line: 0, scope: !94)
!136 = !DILocation(line: 95, column: 41, scope: !94)
!137 = !{!138, !139, i64 4}
!138 = !{!"xdp_md", !139, i64 0, !139, i64 4, !139, i64 8, !139, i64 12, !139, i64 16, !139, i64 20}
!139 = !{!"int", !140, i64 0}
!140 = !{!"omnipotent char", !141, i64 0}
!141 = !{!"Simple C/C++ TBAA"}
!142 = !DILocation(line: 95, column: 30, scope: !94)
!143 = !DILocation(line: 95, column: 22, scope: !94)
!144 = !DILocation(line: 96, column: 37, scope: !94)
!145 = !{!138, !139, i64 0}
!146 = !DILocation(line: 96, column: 26, scope: !94)
!147 = !DILocation(line: 96, column: 18, scope: !94)
!148 = !DILocation(line: 103, column: 14, scope: !149)
!149 = distinct !DILexicalBlock(scope: !94, file: !3, line: 103, column: 9)
!150 = !DILocation(line: 103, column: 23, scope: !149)
!151 = !DILocation(line: 103, column: 9, scope: !94)
!152 = !DILocation(line: 106, column: 14, scope: !153)
!153 = distinct !DILexicalBlock(scope: !94, file: !3, line: 106, column: 9)
!154 = !{!155, !156, i64 12}
!155 = !{!"ethhdr", !140, i64 0, !140, i64 6, !156, i64 12}
!156 = !{!"short", !140, i64 0}
!157 = !DILocation(line: 106, column: 9, scope: !94)
!158 = !DILocalVariable(name: "data", arg: 1, scope: !159, file: !3, line: 58, type: !47)
!159 = distinct !DISubprogram(name: "getProtocolIPv4", scope: !3, file: !3, line: 58, type: !160, scopeLine: 58, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !163)
!160 = !DISubroutineType(types: !161)
!161 = !{!75, !47, !162, !47}
!162 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !124, size: 64)
!163 = !{!158, !164, !165, !166}
!164 = !DILocalVariable(name: "nh_off", arg: 2, scope: !159, file: !3, line: 58, type: !162)
!165 = !DILocalVariable(name: "data_end", arg: 3, scope: !159, file: !3, line: 58, type: !47)
!166 = !DILocalVariable(name: "iph", scope: !159, file: !3, line: 59, type: !167)
!167 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !168, size: 64)
!168 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !169, line: 44, size: 160, elements: !170)
!169 = !DIFile(filename: "/usr/include/netinet/ip.h", directory: "", checksumkind: CSK_MD5, checksum: "dfda1c4995d671533981865d28817074")
!170 = !{!171, !172, !173, !176, !177, !178, !179, !180, !181, !182, !183}
!171 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !168, file: !169, line: 47, baseType: !7, size: 4, flags: DIFlagBitField, extraData: i64 0)
!172 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !168, file: !169, line: 48, baseType: !7, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!173 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !168, file: !169, line: 55, baseType: !174, size: 8, offset: 8)
!174 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !50, line: 24, baseType: !175)
!175 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !52, line: 38, baseType: !117)
!176 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !168, file: !169, line: 56, baseType: !130, size: 16, offset: 16)
!177 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !168, file: !169, line: 57, baseType: !130, size: 16, offset: 32)
!178 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !168, file: !169, line: 58, baseType: !130, size: 16, offset: 48)
!179 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !168, file: !169, line: 59, baseType: !174, size: 8, offset: 64)
!180 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !168, file: !169, line: 60, baseType: !174, size: 8, offset: 72)
!181 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !168, file: !169, line: 61, baseType: !130, size: 16, offset: 80)
!182 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !168, file: !169, line: 62, baseType: !49, size: 32, offset: 96)
!183 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !168, file: !169, line: 63, baseType: !49, size: 32, offset: 128)
!184 = !DILocation(line: 0, scope: !159, inlinedAt: !185)
!185 = distinct !DILocation(line: 107, column: 19, scope: !153)
!186 = !DILocation(line: 62, column: 24, scope: !187, inlinedAt: !185)
!187 = distinct !DILexicalBlock(scope: !159, file: !3, line: 62, column: 9)
!188 = !DILocation(line: 62, column: 47, scope: !187, inlinedAt: !185)
!189 = !DILocation(line: 62, column: 9, scope: !159, inlinedAt: !185)
!190 = !DILocalVariable(name: "data", arg: 1, scope: !191, file: !3, line: 78, type: !47)
!191 = distinct !DISubprogram(name: "getProtocolIPv6", scope: !3, file: !3, line: 78, type: !160, scopeLine: 78, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !192)
!192 = !{!190, !193, !194, !195}
!193 = !DILocalVariable(name: "nh_off", arg: 2, scope: !191, file: !3, line: 78, type: !162)
!194 = !DILocalVariable(name: "data_end", arg: 3, scope: !191, file: !3, line: 78, type: !47)
!195 = !DILocalVariable(name: "ip6h", scope: !191, file: !3, line: 79, type: !196)
!196 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !197, size: 64)
!197 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ipv6hdr", file: !198, line: 118, size: 320, elements: !199)
!198 = !DIFile(filename: "/usr/include/linux/ipv6.h", directory: "", checksumkind: CSK_MD5, checksum: "deff6bca6b519042089ed906aa3655c3")
!199 = !{!200, !202, !203, !207, !208, !209, !210}
!200 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !197, file: !198, line: 120, baseType: !201, size: 4, flags: DIFlagBitField, extraData: i64 0)
!201 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !88, line: 21, baseType: !117)
!202 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !197, file: !198, line: 121, baseType: !201, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!203 = !DIDerivedType(tag: DW_TAG_member, name: "flow_lbl", scope: !197, file: !198, line: 128, baseType: !204, size: 24, offset: 8)
!204 = !DICompositeType(tag: DW_TAG_array_type, baseType: !201, size: 24, elements: !205)
!205 = !{!206}
!206 = !DISubrange(count: 3)
!207 = !DIDerivedType(tag: DW_TAG_member, name: "payload_len", scope: !197, file: !198, line: 130, baseType: !120, size: 16, offset: 32)
!208 = !DIDerivedType(tag: DW_TAG_member, name: "nexthdr", scope: !197, file: !198, line: 131, baseType: !201, size: 8, offset: 48)
!209 = !DIDerivedType(tag: DW_TAG_member, name: "hop_limit", scope: !197, file: !198, line: 132, baseType: !201, size: 8, offset: 56)
!210 = !DIDerivedType(tag: DW_TAG_member, scope: !197, file: !198, line: 134, baseType: !211, size: 256, offset: 64)
!211 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !197, file: !198, line: 134, size: 256, elements: !212)
!212 = !{!213, !237}
!213 = !DIDerivedType(tag: DW_TAG_member, scope: !211, file: !198, line: 134, baseType: !214, size: 256)
!214 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !211, file: !198, line: 134, size: 256, elements: !215)
!215 = !{!216, !236}
!216 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !214, file: !198, line: 134, baseType: !217, size: 128)
!217 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "in6_addr", file: !218, line: 33, size: 128, elements: !219)
!218 = !DIFile(filename: "/usr/include/linux/in6.h", directory: "", checksumkind: CSK_MD5, checksum: "8bebb780b45d3fe932cc1d934fa5f5fe")
!219 = !{!220}
!220 = !DIDerivedType(tag: DW_TAG_member, name: "in6_u", scope: !217, file: !218, line: 40, baseType: !221, size: 128)
!221 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !217, file: !218, line: 34, size: 128, elements: !222)
!222 = !{!223, !227, !231}
!223 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr8", scope: !221, file: !218, line: 35, baseType: !224, size: 128)
!224 = !DICompositeType(tag: DW_TAG_array_type, baseType: !201, size: 128, elements: !225)
!225 = !{!226}
!226 = !DISubrange(count: 16)
!227 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr16", scope: !221, file: !218, line: 37, baseType: !228, size: 128)
!228 = !DICompositeType(tag: DW_TAG_array_type, baseType: !120, size: 128, elements: !229)
!229 = !{!230}
!230 = !DISubrange(count: 8)
!231 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr32", scope: !221, file: !218, line: 38, baseType: !232, size: 128)
!232 = !DICompositeType(tag: DW_TAG_array_type, baseType: !233, size: 128, elements: !234)
!233 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !121, line: 30, baseType: !87)
!234 = !{!235}
!235 = !DISubrange(count: 4)
!236 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !214, file: !198, line: 134, baseType: !217, size: 128, offset: 128)
!237 = !DIDerivedType(tag: DW_TAG_member, name: "addrs", scope: !211, file: !198, line: 134, baseType: !238, size: 256)
!238 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !211, file: !198, line: 134, size: 256, elements: !239)
!239 = !{!240, !241}
!240 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !238, file: !198, line: 134, baseType: !217, size: 128)
!241 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !238, file: !198, line: 134, baseType: !217, size: 128, offset: 128)
!242 = !DILocation(line: 0, scope: !191, inlinedAt: !243)
!243 = distinct !DILocation(line: 109, column: 19, scope: !244)
!244 = distinct !DILexicalBlock(scope: !153, file: !3, line: 108, column: 14)
!245 = !DILocation(line: 82, column: 24, scope: !246, inlinedAt: !243)
!246 = distinct !DILexicalBlock(scope: !191, file: !3, line: 82, column: 9)
!247 = !DILocation(line: 82, column: 49, scope: !246, inlinedAt: !243)
!248 = !DILocation(line: 82, column: 9, scope: !191, inlinedAt: !243)
!249 = !DILocation(line: 99, column: 11, scope: !94)
!250 = !DILocation(line: 0, scope: !153)
!251 = !{!140, !140, i64 0}
!252 = !DILocation(line: 113, column: 17, scope: !129)
!253 = !DILocation(line: 113, column: 9, scope: !94)
!254 = !DILocalVariable(name: "data", arg: 1, scope: !255, file: !3, line: 40, type: !47)
!255 = distinct !DISubprogram(name: "getDestPortUDP", scope: !3, file: !3, line: 40, type: !256, scopeLine: 40, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !258)
!256 = !DISubroutineType(types: !257)
!257 = !{!75, !47, !124, !47}
!258 = !{!254, !259, !260, !261}
!259 = !DILocalVariable(name: "nh_off", arg: 2, scope: !255, file: !3, line: 40, type: !124)
!260 = !DILocalVariable(name: "data_end", arg: 3, scope: !255, file: !3, line: 40, type: !47)
!261 = !DILocalVariable(name: "udph", scope: !255, file: !3, line: 41, type: !262)
!262 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !263, size: 64)
!263 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "udphdr", file: !264, line: 23, size: 64, elements: !265)
!264 = !DIFile(filename: "/usr/include/linux/udp.h", directory: "", checksumkind: CSK_MD5, checksum: "53c0d42e1bf6d93b39151764be2d20fb")
!265 = !{!266, !267, !268, !269}
!266 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !263, file: !264, line: 24, baseType: !120, size: 16)
!267 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !263, file: !264, line: 25, baseType: !120, size: 16, offset: 16)
!268 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !263, file: !264, line: 26, baseType: !120, size: 16, offset: 32)
!269 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !263, file: !264, line: 27, baseType: !270, size: 16, offset: 48)
!270 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !121, line: 34, baseType: !122)
!271 = !DILocation(line: 0, scope: !255, inlinedAt: !272)
!272 = distinct !DILocation(line: 114, column: 30, scope: !128)
!273 = !DILocation(line: 41, column: 32, scope: !255, inlinedAt: !272)
!274 = !DILocation(line: 43, column: 23, scope: !275, inlinedAt: !272)
!275 = distinct !DILexicalBlock(scope: !255, file: !3, line: 43, column: 9)
!276 = !DILocation(line: 43, column: 47, scope: !275, inlinedAt: !272)
!277 = !DILocation(line: 43, column: 9, scope: !255, inlinedAt: !272)
!278 = !DILocation(line: 46, column: 18, scope: !255, inlinedAt: !272)
!279 = !{!280, !156, i64 2}
!280 = !{!"udphdr", !156, i64 0, !156, i64 2, !156, i64 4, !156, i64 6}
!281 = !DILocation(line: 46, column: 5, scope: !255, inlinedAt: !272)
!282 = !DILocation(line: 0, scope: !128)
!283 = !DILocation(line: 116, column: 13, scope: !128)
!284 = !DILocation(line: 117, column: 13, scope: !132)
!285 = !DILocation(line: 0, scope: !132)
!286 = !DILocation(line: 117, column: 22, scope: !132)
!287 = !{!139, !139, i64 0}
!288 = !DILocation(line: 118, column: 27, scope: !132)
!289 = !DILocation(line: 119, column: 17, scope: !290)
!290 = distinct !DILexicalBlock(scope: !132, file: !3, line: 119, column: 17)
!291 = !DILocation(line: 119, column: 17, scope: !132)
!292 = !DILocation(line: 120, column: 24, scope: !290)
!293 = !{!294, !294, i64 0}
!294 = !{!"long", !140, i64 0}
!295 = !DILocation(line: 120, column: 17, scope: !290)
!296 = !DILocalVariable(name: "data", arg: 1, scope: !297, file: !3, line: 24, type: !47)
!297 = distinct !DISubprogram(name: "editDestPortUDP", scope: !3, file: !3, line: 24, type: !298, scopeLine: 24, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !300)
!298 = !DISubroutineType(cc: DW_CC_nocall, types: !299)
!299 = !{null, !47, !124, !47, !75}
!300 = !{!296, !301, !302, !303, !304}
!301 = !DILocalVariable(name: "nh_off", arg: 2, scope: !297, file: !3, line: 24, type: !124)
!302 = !DILocalVariable(name: "data_end", arg: 3, scope: !297, file: !3, line: 24, type: !47)
!303 = !DILocalVariable(name: "port", arg: 4, scope: !297, file: !3, line: 24, type: !75)
!304 = !DILocalVariable(name: "udph", scope: !297, file: !3, line: 25, type: !262)
!305 = !DILocation(line: 0, scope: !297, inlinedAt: !306)
!306 = distinct !DILocation(line: 125, column: 13, scope: !307)
!307 = distinct !DILexicalBlock(scope: !308, file: !3, line: 124, column: 37)
!308 = distinct !DILexicalBlock(scope: !133, file: !3, line: 124, column: 18)
!309 = !DILocation(line: 27, column: 9, scope: !297, inlinedAt: !306)
!310 = !DILocation(line: 28, column: 15, scope: !311, inlinedAt: !306)
!311 = distinct !DILexicalBlock(scope: !297, file: !3, line: 27, column: 9)
!312 = !DILocation(line: 28, column: 20, scope: !311, inlinedAt: !306)
!313 = !DILocation(line: 28, column: 9, scope: !311, inlinedAt: !306)
!314 = !DILocation(line: 123, column: 9, scope: !133)
!315 = !DILocation(line: 130, column: 1, scope: !94)
