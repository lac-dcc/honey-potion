; ModuleID = '/run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/benchmarks/dropudp/prog.bpf.c'
source_filename = "/run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/benchmarks/dropudp/prog.bpf.c"
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
define dso_local i32 @dropXDP(ptr nocapture noundef readonly %0) #0 section "xdp_drop_UDP" !dbg !95 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata ptr %0, metadata !108, metadata !DIExpression()), !dbg !136
  %3 = getelementptr inbounds %struct.xdp_md, ptr %0, i64 0, i32 1, !dbg !137
  %4 = load i32, ptr %3, align 4, !dbg !137, !tbaa !138
  %5 = zext i32 %4 to i64, !dbg !143
  %6 = inttoptr i64 %5 to ptr, !dbg !144
  call void @llvm.dbg.value(metadata ptr %6, metadata !109, metadata !DIExpression()), !dbg !136
  %7 = load i32, ptr %0, align 4, !dbg !145, !tbaa !146
  %8 = zext i32 %7 to i64, !dbg !147
  %9 = inttoptr i64 %8 to ptr, !dbg !148
  call void @llvm.dbg.value(metadata ptr %9, metadata !110, metadata !DIExpression()), !dbg !136
  call void @llvm.dbg.value(metadata ptr %9, metadata !111, metadata !DIExpression()), !dbg !136
  call void @llvm.dbg.value(metadata i64 14, metadata !124, metadata !DIExpression()), !dbg !136
  call void @llvm.dbg.value(metadata i32 0, metadata !127, metadata !DIExpression()), !dbg !136
  %10 = getelementptr i8, ptr %9, i64 14, !dbg !149
  %11 = icmp ugt ptr %10, %6, !dbg !151
  br i1 %11, label %47, label %12, !dbg !152

12:                                               ; preds = %1
  %13 = getelementptr inbounds %struct.ethhdr, ptr %9, i64 0, i32 2, !dbg !153
  %14 = load i16, ptr %13, align 1, !dbg !153, !tbaa !155
  switch i16 %14, label %47 [
    i16 8, label %15
    i16 -8826, label %18
  ], !dbg !158

15:                                               ; preds = %12
  call void @llvm.dbg.value(metadata ptr %9, metadata !159, metadata !DIExpression()), !dbg !185
  call void @llvm.dbg.value(metadata ptr undef, metadata !165, metadata !DIExpression()), !dbg !185
  call void @llvm.dbg.value(metadata ptr %6, metadata !166, metadata !DIExpression()), !dbg !185
  call void @llvm.dbg.value(metadata ptr %10, metadata !167, metadata !DIExpression()), !dbg !185
  %16 = getelementptr i8, ptr %9, i64 34, !dbg !187
  %17 = icmp ugt ptr %16, %6, !dbg !189
  br i1 %17, label %47, label %21, !dbg !190

18:                                               ; preds = %12
  call void @llvm.dbg.value(metadata ptr %9, metadata !191, metadata !DIExpression()), !dbg !243
  call void @llvm.dbg.value(metadata ptr undef, metadata !194, metadata !DIExpression()), !dbg !243
  call void @llvm.dbg.value(metadata ptr %6, metadata !195, metadata !DIExpression()), !dbg !243
  call void @llvm.dbg.value(metadata ptr %10, metadata !196, metadata !DIExpression()), !dbg !243
  %19 = getelementptr i8, ptr %9, i64 54, !dbg !246
  %20 = icmp ugt ptr %19, %6, !dbg !248
  br i1 %20, label %47, label %21, !dbg !249

21:                                               ; preds = %18, %15
  %22 = phi i64 [ 23, %15 ], [ 20, %18 ]
  %23 = phi i64 [ 34, %15 ], [ 54, %18 ], !dbg !250
  %24 = getelementptr i8, ptr %9, i64 %22, !dbg !251
  %25 = load i8, ptr %24, align 1, !dbg !251, !tbaa !252
  call void @llvm.dbg.value(metadata i8 %25, metadata !127, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !136
  %26 = icmp eq i8 %25, 17, !dbg !253
  br i1 %26, label %27, label %47, !dbg !254

27:                                               ; preds = %21
  call void @llvm.dbg.value(metadata i64 %23, metadata !124, metadata !DIExpression()), !dbg !136
  call void @llvm.dbg.value(metadata ptr %9, metadata !255, metadata !DIExpression()), !dbg !272
  call void @llvm.dbg.value(metadata i64 %23, metadata !260, metadata !DIExpression()), !dbg !272
  call void @llvm.dbg.value(metadata ptr %6, metadata !261, metadata !DIExpression()), !dbg !272
  %28 = getelementptr i8, ptr %9, i64 %23, !dbg !274
  call void @llvm.dbg.value(metadata ptr %28, metadata !262, metadata !DIExpression()), !dbg !272
  %29 = getelementptr i8, ptr %28, i64 8, !dbg !275
  %30 = icmp ugt ptr %29, %6, !dbg !277
  br i1 %30, label %34, label %31, !dbg !278

31:                                               ; preds = %27
  %32 = getelementptr inbounds %struct.udphdr, ptr %28, i64 0, i32 1, !dbg !279
  %33 = load i16, ptr %32, align 2, !dbg !279, !tbaa !280
  br label %34, !dbg !282

34:                                               ; preds = %27, %31
  %35 = phi i16 [ %33, %31 ], [ 0, %27 ]
  %36 = tail call i16 @llvm.bswap.i16(i16 %35)
  call void @llvm.dbg.value(metadata i16 %36, metadata !128, metadata !DIExpression()), !dbg !283
  switch i16 %36, label %47 [
    i16 3000, label %37
    i16 3001, label %43
  ], !dbg !284

37:                                               ; preds = %34
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #3, !dbg !285
  call void @llvm.dbg.value(metadata i32 3000, metadata !132, metadata !DIExpression()), !dbg !286
  store i32 3000, ptr %2, align 4, !dbg !287, !tbaa !288
  call void @llvm.dbg.value(metadata ptr %2, metadata !132, metadata !DIExpression(DW_OP_deref)), !dbg !286
  %38 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @map, ptr noundef nonnull %2) #3, !dbg !289
  call void @llvm.dbg.value(metadata ptr %38, metadata !135, metadata !DIExpression()), !dbg !286
  %39 = icmp eq ptr %38, null, !dbg !290
  br i1 %39, label %46, label %40, !dbg !292

40:                                               ; preds = %37
  %41 = load i64, ptr %38, align 8, !dbg !293, !tbaa !294
  %42 = add nsw i64 %41, 1, !dbg !293
  store i64 %42, ptr %38, align 8, !dbg !293, !tbaa !294
  br label %46, !dbg !296

43:                                               ; preds = %34
  call void @llvm.dbg.value(metadata i64 %23, metadata !124, metadata !DIExpression()), !dbg !136
  call void @llvm.dbg.value(metadata ptr %9, metadata !297, metadata !DIExpression()), !dbg !306
  call void @llvm.dbg.value(metadata i64 %23, metadata !302, metadata !DIExpression()), !dbg !306
  call void @llvm.dbg.value(metadata ptr %6, metadata !303, metadata !DIExpression()), !dbg !306
  call void @llvm.dbg.value(metadata i32 3000, metadata !304, metadata !DIExpression()), !dbg !306
  call void @llvm.dbg.value(metadata ptr %28, metadata !305, metadata !DIExpression()), !dbg !306
  br i1 %30, label %47, label %44, !dbg !310

44:                                               ; preds = %43
  %45 = getelementptr inbounds %struct.udphdr, ptr %28, i64 0, i32 1, !dbg !311
  store i16 -18421, ptr %45, align 2, !dbg !313, !tbaa !280
  br label %47, !dbg !314

46:                                               ; preds = %37, %40
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #3, !dbg !315
  br label %47

47:                                               ; preds = %34, %12, %43, %44, %18, %15, %21, %46, %1
  %48 = phi i32 [ 1, %46 ], [ 0, %1 ], [ 2, %21 ], [ 2, %15 ], [ 2, %18 ], [ 2, %44 ], [ 2, %43 ], [ 2, %12 ], [ 2, %34 ], !dbg !136
  ret i32 %48, !dbg !316
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i16 @llvm.bswap.i16(i16) #2

attributes #0 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!90, !91, !92, !93}
!llvm.ident = !{!94}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "map", scope: !2, file: !58, line: 13, type: !71, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 16.0.6", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !46, globals: !55, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/benchmarks/dropudp/prog.bpf.c", directory: "/run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/benchmarks/dropudp", checksumkind: CSK_MD5, checksum: "d9e969f363a81ec6370a7209b0dad34e")
!4 = !{!5, !14}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 6187, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/include/linux/bpf.h", directory: "", checksumkind: CSK_MD5, checksum: "0e8ee22284445bf280d4dd8fb9f52271")
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
!55 = !{!56, !0, !63}
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !58, line: 132, type: !59, isLocal: false, isDefinition: true)
!58 = !DIFile(filename: "prog.bpf.c", directory: "/run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/benchmarks/dropudp", checksumkind: CSK_MD5, checksum: "d9e969f363a81ec6370a7209b0dad34e")
!59 = !DICompositeType(tag: DW_TAG_array_type, baseType: !60, size: 104, elements: !61)
!60 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!61 = !{!62}
!62 = !DISubrange(count: 13)
!63 = !DIGlobalVariableExpression(var: !64, expr: !DIExpression())
!64 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !65, line: 56, type: !66, isLocal: true, isDefinition: true)
!65 = !DIFile(filename: "/usr/include/bpf/bpf_helper_defs.h", directory: "", checksumkind: CSK_MD5, checksum: "7422ca06c9dc86eba2f268a57d8acf2f")
!66 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !67, size: 64)
!67 = !DISubroutineType(types: !68)
!68 = !{!47, !47, !69}
!69 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !70, size: 64)
!70 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!71 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !58, line: 8, size: 256, elements: !72)
!72 = !{!73, !79, !84, !86}
!73 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !71, file: !58, line: 9, baseType: !74, size: 64)
!74 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !75, size: 64)
!75 = !DICompositeType(tag: DW_TAG_array_type, baseType: !76, size: 192, elements: !77)
!76 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!77 = !{!78}
!78 = !DISubrange(count: 6)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !71, file: !58, line: 10, baseType: !80, size: 64, offset: 64)
!80 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !81, size: 64)
!81 = !DICompositeType(tag: DW_TAG_array_type, baseType: !76, size: 32, elements: !82)
!82 = !{!83}
!83 = !DISubrange(count: 1)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !71, file: !58, line: 11, baseType: !85, size: 64, offset: 128)
!85 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !48, size: 64)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !71, file: !58, line: 12, baseType: !87, size: 64, offset: 192)
!87 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !88, size: 64)
!88 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !89, line: 27, baseType: !7)
!89 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!90 = !{i32 7, !"Dwarf Version", i32 5}
!91 = !{i32 2, !"Debug Info Version", i32 3}
!92 = !{i32 1, !"wchar_size", i32 4}
!93 = !{i32 7, !"frame-pointer", i32 2}
!94 = !{!"clang version 16.0.6"}
!95 = distinct !DISubprogram(name: "dropXDP", scope: !58, file: !58, line: 94, type: !96, scopeLine: 94, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !107)
!96 = !DISubroutineType(types: !97)
!97 = !{!76, !98}
!98 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !99, size: 64)
!99 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 6198, size: 192, elements: !100)
!100 = !{!101, !102, !103, !104, !105, !106}
!101 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !99, file: !6, line: 6199, baseType: !88, size: 32)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !99, file: !6, line: 6200, baseType: !88, size: 32, offset: 32)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !99, file: !6, line: 6201, baseType: !88, size: 32, offset: 64)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !99, file: !6, line: 6203, baseType: !88, size: 32, offset: 96)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !99, file: !6, line: 6204, baseType: !88, size: 32, offset: 128)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "egress_ifindex", scope: !99, file: !6, line: 6206, baseType: !88, size: 32, offset: 160)
!107 = !{!108, !109, !110, !111, !124, !127, !128, !132, !135}
!108 = !DILocalVariable(name: "ctx", arg: 1, scope: !95, file: !58, line: 94, type: !98)
!109 = !DILocalVariable(name: "data_end", scope: !95, file: !58, line: 95, type: !47)
!110 = !DILocalVariable(name: "data", scope: !95, file: !58, line: 96, type: !47)
!111 = !DILocalVariable(name: "eth", scope: !95, file: !58, line: 97, type: !112)
!112 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !113, size: 64)
!113 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !114, line: 173, size: 112, elements: !115)
!114 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "163f54fb1af2e21fea410f14eb18fa76")
!115 = !{!116, !119, !120}
!116 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !113, file: !114, line: 174, baseType: !117, size: 48)
!117 = !DICompositeType(tag: DW_TAG_array_type, baseType: !118, size: 48, elements: !77)
!118 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !113, file: !114, line: 175, baseType: !117, size: 48, offset: 48)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !113, file: !114, line: 176, baseType: !121, size: 16, offset: 96)
!121 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !122, line: 28, baseType: !123)
!122 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "64bcf4b731906682de6e750679b9f4a2")
!123 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !89, line: 24, baseType: !54)
!124 = !DILocalVariable(name: "nh_off", scope: !95, file: !58, line: 99, type: !125)
!125 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !89, line: 31, baseType: !126)
!126 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!127 = !DILocalVariable(name: "ipproto", scope: !95, file: !58, line: 100, type: !88)
!128 = !DILocalVariable(name: "dest_port", scope: !129, file: !58, line: 114, type: !131)
!129 = distinct !DILexicalBlock(scope: !130, file: !58, line: 113, column: 33)
!130 = distinct !DILexicalBlock(scope: !95, file: !58, line: 113, column: 9)
!131 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !50, line: 25, baseType: !53)
!132 = !DILocalVariable(name: "index", scope: !133, file: !58, line: 117, type: !49)
!133 = distinct !DILexicalBlock(scope: !134, file: !58, line: 116, column: 32)
!134 = distinct !DILexicalBlock(scope: !129, file: !58, line: 116, column: 13)
!135 = !DILocalVariable(name: "value", scope: !133, file: !58, line: 118, type: !85)
!136 = !DILocation(line: 0, scope: !95)
!137 = !DILocation(line: 95, column: 41, scope: !95)
!138 = !{!139, !140, i64 4}
!139 = !{!"xdp_md", !140, i64 0, !140, i64 4, !140, i64 8, !140, i64 12, !140, i64 16, !140, i64 20}
!140 = !{!"int", !141, i64 0}
!141 = !{!"omnipotent char", !142, i64 0}
!142 = !{!"Simple C/C++ TBAA"}
!143 = !DILocation(line: 95, column: 30, scope: !95)
!144 = !DILocation(line: 95, column: 22, scope: !95)
!145 = !DILocation(line: 96, column: 37, scope: !95)
!146 = !{!139, !140, i64 0}
!147 = !DILocation(line: 96, column: 26, scope: !95)
!148 = !DILocation(line: 96, column: 18, scope: !95)
!149 = !DILocation(line: 103, column: 14, scope: !150)
!150 = distinct !DILexicalBlock(scope: !95, file: !58, line: 103, column: 9)
!151 = !DILocation(line: 103, column: 23, scope: !150)
!152 = !DILocation(line: 103, column: 9, scope: !95)
!153 = !DILocation(line: 106, column: 14, scope: !154)
!154 = distinct !DILexicalBlock(scope: !95, file: !58, line: 106, column: 9)
!155 = !{!156, !157, i64 12}
!156 = !{!"ethhdr", !141, i64 0, !141, i64 6, !157, i64 12}
!157 = !{!"short", !141, i64 0}
!158 = !DILocation(line: 106, column: 9, scope: !95)
!159 = !DILocalVariable(name: "data", arg: 1, scope: !160, file: !58, line: 58, type: !47)
!160 = distinct !DISubprogram(name: "getProtocolIPv4", scope: !58, file: !58, line: 58, type: !161, scopeLine: 58, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !164)
!161 = !DISubroutineType(types: !162)
!162 = !{!76, !47, !163, !47}
!163 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !125, size: 64)
!164 = !{!159, !165, !166, !167}
!165 = !DILocalVariable(name: "nh_off", arg: 2, scope: !160, file: !58, line: 58, type: !163)
!166 = !DILocalVariable(name: "data_end", arg: 3, scope: !160, file: !58, line: 58, type: !47)
!167 = !DILocalVariable(name: "iph", scope: !160, file: !58, line: 59, type: !168)
!168 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !169, size: 64)
!169 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !170, line: 44, size: 160, elements: !171)
!170 = !DIFile(filename: "/usr/include/netinet/ip.h", directory: "", checksumkind: CSK_MD5, checksum: "193a65b514ee8ae0dff1616565a4b882")
!171 = !{!172, !173, !174, !177, !178, !179, !180, !181, !182, !183, !184}
!172 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !169, file: !170, line: 47, baseType: !7, size: 4, flags: DIFlagBitField, extraData: i64 0)
!173 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !169, file: !170, line: 48, baseType: !7, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!174 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !169, file: !170, line: 55, baseType: !175, size: 8, offset: 8)
!175 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !50, line: 24, baseType: !176)
!176 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !52, line: 38, baseType: !118)
!177 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !169, file: !170, line: 56, baseType: !131, size: 16, offset: 16)
!178 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !169, file: !170, line: 57, baseType: !131, size: 16, offset: 32)
!179 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !169, file: !170, line: 58, baseType: !131, size: 16, offset: 48)
!180 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !169, file: !170, line: 59, baseType: !175, size: 8, offset: 64)
!181 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !169, file: !170, line: 60, baseType: !175, size: 8, offset: 72)
!182 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !169, file: !170, line: 61, baseType: !131, size: 16, offset: 80)
!183 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !169, file: !170, line: 62, baseType: !49, size: 32, offset: 96)
!184 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !169, file: !170, line: 63, baseType: !49, size: 32, offset: 128)
!185 = !DILocation(line: 0, scope: !160, inlinedAt: !186)
!186 = distinct !DILocation(line: 107, column: 19, scope: !154)
!187 = !DILocation(line: 62, column: 24, scope: !188, inlinedAt: !186)
!188 = distinct !DILexicalBlock(scope: !160, file: !58, line: 62, column: 9)
!189 = !DILocation(line: 62, column: 47, scope: !188, inlinedAt: !186)
!190 = !DILocation(line: 62, column: 9, scope: !160, inlinedAt: !186)
!191 = !DILocalVariable(name: "data", arg: 1, scope: !192, file: !58, line: 78, type: !47)
!192 = distinct !DISubprogram(name: "getProtocolIPv6", scope: !58, file: !58, line: 78, type: !161, scopeLine: 78, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !193)
!193 = !{!191, !194, !195, !196}
!194 = !DILocalVariable(name: "nh_off", arg: 2, scope: !192, file: !58, line: 78, type: !163)
!195 = !DILocalVariable(name: "data_end", arg: 3, scope: !192, file: !58, line: 78, type: !47)
!196 = !DILocalVariable(name: "ip6h", scope: !192, file: !58, line: 79, type: !197)
!197 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !198, size: 64)
!198 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ipv6hdr", file: !199, line: 118, size: 320, elements: !200)
!199 = !DIFile(filename: "/usr/include/linux/ipv6.h", directory: "", checksumkind: CSK_MD5, checksum: "5119f4e1c8becf2f187fa2b4015ad457")
!200 = !{!201, !203, !204, !208, !209, !210, !211}
!201 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !198, file: !199, line: 120, baseType: !202, size: 4, flags: DIFlagBitField, extraData: i64 0)
!202 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !89, line: 21, baseType: !118)
!203 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !198, file: !199, line: 121, baseType: !202, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!204 = !DIDerivedType(tag: DW_TAG_member, name: "flow_lbl", scope: !198, file: !199, line: 128, baseType: !205, size: 24, offset: 8)
!205 = !DICompositeType(tag: DW_TAG_array_type, baseType: !202, size: 24, elements: !206)
!206 = !{!207}
!207 = !DISubrange(count: 3)
!208 = !DIDerivedType(tag: DW_TAG_member, name: "payload_len", scope: !198, file: !199, line: 130, baseType: !121, size: 16, offset: 32)
!209 = !DIDerivedType(tag: DW_TAG_member, name: "nexthdr", scope: !198, file: !199, line: 131, baseType: !202, size: 8, offset: 48)
!210 = !DIDerivedType(tag: DW_TAG_member, name: "hop_limit", scope: !198, file: !199, line: 132, baseType: !202, size: 8, offset: 56)
!211 = !DIDerivedType(tag: DW_TAG_member, scope: !198, file: !199, line: 134, baseType: !212, size: 256, offset: 64)
!212 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !198, file: !199, line: 134, size: 256, elements: !213)
!213 = !{!214, !238}
!214 = !DIDerivedType(tag: DW_TAG_member, scope: !212, file: !199, line: 134, baseType: !215, size: 256)
!215 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !212, file: !199, line: 134, size: 256, elements: !216)
!216 = !{!217, !237}
!217 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !215, file: !199, line: 134, baseType: !218, size: 128)
!218 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "in6_addr", file: !219, line: 33, size: 128, elements: !220)
!219 = !DIFile(filename: "/usr/include/linux/in6.h", directory: "", checksumkind: CSK_MD5, checksum: "8bebb780b45d3fe932cc1d934fa5f5fe")
!220 = !{!221}
!221 = !DIDerivedType(tag: DW_TAG_member, name: "in6_u", scope: !218, file: !219, line: 40, baseType: !222, size: 128)
!222 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !218, file: !219, line: 34, size: 128, elements: !223)
!223 = !{!224, !228, !232}
!224 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr8", scope: !222, file: !219, line: 35, baseType: !225, size: 128)
!225 = !DICompositeType(tag: DW_TAG_array_type, baseType: !202, size: 128, elements: !226)
!226 = !{!227}
!227 = !DISubrange(count: 16)
!228 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr16", scope: !222, file: !219, line: 37, baseType: !229, size: 128)
!229 = !DICompositeType(tag: DW_TAG_array_type, baseType: !121, size: 128, elements: !230)
!230 = !{!231}
!231 = !DISubrange(count: 8)
!232 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr32", scope: !222, file: !219, line: 38, baseType: !233, size: 128)
!233 = !DICompositeType(tag: DW_TAG_array_type, baseType: !234, size: 128, elements: !235)
!234 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !122, line: 30, baseType: !88)
!235 = !{!236}
!236 = !DISubrange(count: 4)
!237 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !215, file: !199, line: 134, baseType: !218, size: 128, offset: 128)
!238 = !DIDerivedType(tag: DW_TAG_member, name: "addrs", scope: !212, file: !199, line: 134, baseType: !239, size: 256)
!239 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !212, file: !199, line: 134, size: 256, elements: !240)
!240 = !{!241, !242}
!241 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !239, file: !199, line: 134, baseType: !218, size: 128)
!242 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !239, file: !199, line: 134, baseType: !218, size: 128, offset: 128)
!243 = !DILocation(line: 0, scope: !192, inlinedAt: !244)
!244 = distinct !DILocation(line: 109, column: 19, scope: !245)
!245 = distinct !DILexicalBlock(scope: !154, file: !58, line: 108, column: 14)
!246 = !DILocation(line: 82, column: 24, scope: !247, inlinedAt: !244)
!247 = distinct !DILexicalBlock(scope: !192, file: !58, line: 82, column: 9)
!248 = !DILocation(line: 82, column: 49, scope: !247, inlinedAt: !244)
!249 = !DILocation(line: 82, column: 9, scope: !192, inlinedAt: !244)
!250 = !DILocation(line: 99, column: 11, scope: !95)
!251 = !DILocation(line: 0, scope: !154)
!252 = !{!141, !141, i64 0}
!253 = !DILocation(line: 113, column: 17, scope: !130)
!254 = !DILocation(line: 113, column: 9, scope: !95)
!255 = !DILocalVariable(name: "data", arg: 1, scope: !256, file: !58, line: 40, type: !47)
!256 = distinct !DISubprogram(name: "getDestPortUDP", scope: !58, file: !58, line: 40, type: !257, scopeLine: 40, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !259)
!257 = !DISubroutineType(types: !258)
!258 = !{!76, !47, !125, !47}
!259 = !{!255, !260, !261, !262}
!260 = !DILocalVariable(name: "nh_off", arg: 2, scope: !256, file: !58, line: 40, type: !125)
!261 = !DILocalVariable(name: "data_end", arg: 3, scope: !256, file: !58, line: 40, type: !47)
!262 = !DILocalVariable(name: "udph", scope: !256, file: !58, line: 41, type: !263)
!263 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !264, size: 64)
!264 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "udphdr", file: !265, line: 23, size: 64, elements: !266)
!265 = !DIFile(filename: "/usr/include/linux/udp.h", directory: "", checksumkind: CSK_MD5, checksum: "53c0d42e1bf6d93b39151764be2d20fb")
!266 = !{!267, !268, !269, !270}
!267 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !264, file: !265, line: 24, baseType: !121, size: 16)
!268 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !264, file: !265, line: 25, baseType: !121, size: 16, offset: 16)
!269 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !264, file: !265, line: 26, baseType: !121, size: 16, offset: 32)
!270 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !264, file: !265, line: 27, baseType: !271, size: 16, offset: 48)
!271 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !122, line: 34, baseType: !123)
!272 = !DILocation(line: 0, scope: !256, inlinedAt: !273)
!273 = distinct !DILocation(line: 114, column: 30, scope: !129)
!274 = !DILocation(line: 41, column: 32, scope: !256, inlinedAt: !273)
!275 = !DILocation(line: 43, column: 23, scope: !276, inlinedAt: !273)
!276 = distinct !DILexicalBlock(scope: !256, file: !58, line: 43, column: 9)
!277 = !DILocation(line: 43, column: 47, scope: !276, inlinedAt: !273)
!278 = !DILocation(line: 43, column: 9, scope: !256, inlinedAt: !273)
!279 = !DILocation(line: 46, column: 18, scope: !256, inlinedAt: !273)
!280 = !{!281, !157, i64 2}
!281 = !{!"udphdr", !157, i64 0, !157, i64 2, !157, i64 4, !157, i64 6}
!282 = !DILocation(line: 46, column: 5, scope: !256, inlinedAt: !273)
!283 = !DILocation(line: 0, scope: !129)
!284 = !DILocation(line: 116, column: 13, scope: !129)
!285 = !DILocation(line: 117, column: 13, scope: !133)
!286 = !DILocation(line: 0, scope: !133)
!287 = !DILocation(line: 117, column: 22, scope: !133)
!288 = !{!140, !140, i64 0}
!289 = !DILocation(line: 118, column: 27, scope: !133)
!290 = !DILocation(line: 119, column: 17, scope: !291)
!291 = distinct !DILexicalBlock(scope: !133, file: !58, line: 119, column: 17)
!292 = !DILocation(line: 119, column: 17, scope: !133)
!293 = !DILocation(line: 120, column: 24, scope: !291)
!294 = !{!295, !295, i64 0}
!295 = !{!"long", !141, i64 0}
!296 = !DILocation(line: 120, column: 17, scope: !291)
!297 = !DILocalVariable(name: "data", arg: 1, scope: !298, file: !58, line: 24, type: !47)
!298 = distinct !DISubprogram(name: "editDestPortUDP", scope: !58, file: !58, line: 24, type: !299, scopeLine: 24, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !301)
!299 = !DISubroutineType(types: !300)
!300 = !{null, !47, !125, !47, !76}
!301 = !{!297, !302, !303, !304, !305}
!302 = !DILocalVariable(name: "nh_off", arg: 2, scope: !298, file: !58, line: 24, type: !125)
!303 = !DILocalVariable(name: "data_end", arg: 3, scope: !298, file: !58, line: 24, type: !47)
!304 = !DILocalVariable(name: "port", arg: 4, scope: !298, file: !58, line: 24, type: !76)
!305 = !DILocalVariable(name: "udph", scope: !298, file: !58, line: 25, type: !263)
!306 = !DILocation(line: 0, scope: !298, inlinedAt: !307)
!307 = distinct !DILocation(line: 125, column: 13, scope: !308)
!308 = distinct !DILexicalBlock(scope: !309, file: !58, line: 124, column: 37)
!309 = distinct !DILexicalBlock(scope: !134, file: !58, line: 124, column: 18)
!310 = !DILocation(line: 27, column: 9, scope: !298, inlinedAt: !307)
!311 = !DILocation(line: 28, column: 15, scope: !312, inlinedAt: !307)
!312 = distinct !DILexicalBlock(scope: !298, file: !58, line: 27, column: 9)
!313 = !DILocation(line: 28, column: 20, scope: !312, inlinedAt: !307)
!314 = !DILocation(line: 28, column: 9, scope: !312, inlinedAt: !307)
!315 = !DILocation(line: 123, column: 9, scope: !134)
!316 = !DILocation(line: 130, column: 1, scope: !95)
