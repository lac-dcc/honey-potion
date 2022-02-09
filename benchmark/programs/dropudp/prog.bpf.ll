; ModuleID = 'prog.bpf.c'
source_filename = "prog.bpf.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }

@map = dso_local global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 1, i32 0 }, section "maps", align 4, !dbg !0
@_license = dso_local global [13 x i8] c"Dual BSD/GPL\00", section "license", align 1, !dbg !53
@llvm.compiler.used = appending global [3 x i8*] [i8* getelementptr inbounds ([13 x i8], [13 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_md*)* @dropXDP to i8*), i8* bitcast (%struct.bpf_map_def* @map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @dropXDP(%struct.xdp_md* nocapture readonly %0) #0 section "xdp_drop_UDP" !dbg !80 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !95, metadata !DIExpression()), !dbg !126
  %3 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !127
  %4 = load i32, i32* %3, align 4, !dbg !127, !tbaa !128
  %5 = zext i32 %4 to i64, !dbg !133
  %6 = inttoptr i64 %5 to i8*, !dbg !134
  call void @llvm.dbg.value(metadata i8* %6, metadata !96, metadata !DIExpression()), !dbg !126
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !135
  %8 = load i32, i32* %7, align 4, !dbg !135, !tbaa !136
  %9 = zext i32 %8 to i64, !dbg !137
  %10 = inttoptr i64 %9 to i8*, !dbg !138
  call void @llvm.dbg.value(metadata i8* %10, metadata !97, metadata !DIExpression()), !dbg !126
  call void @llvm.dbg.value(metadata i8* %10, metadata !98, metadata !DIExpression()), !dbg !126
  call void @llvm.dbg.value(metadata i64 14, metadata !113, metadata !DIExpression()), !dbg !126
  call void @llvm.dbg.value(metadata i32 0, metadata !116, metadata !DIExpression()), !dbg !126
  %11 = getelementptr i8, i8* %10, i64 14, !dbg !139
  %12 = icmp ugt i8* %11, %6, !dbg !141
  br i1 %12, label %53, label %13, !dbg !142

13:                                               ; preds = %1
  %14 = inttoptr i64 %9 to %struct.ethhdr*, !dbg !143
  call void @llvm.dbg.value(metadata %struct.ethhdr* %14, metadata !98, metadata !DIExpression()), !dbg !126
  %15 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %14, i64 0, i32 2, !dbg !144
  %16 = load i16, i16* %15, align 1, !dbg !144, !tbaa !146
  switch i16 %16, label %53 [
    i16 8, label %17
    i16 -8826, label %20
  ], !dbg !149

17:                                               ; preds = %13
  call void @llvm.dbg.value(metadata i8* %10, metadata !150, metadata !DIExpression()), !dbg !176
  call void @llvm.dbg.value(metadata i64* undef, metadata !156, metadata !DIExpression()), !dbg !176
  call void @llvm.dbg.value(metadata i8* %6, metadata !157, metadata !DIExpression()), !dbg !176
  call void @llvm.dbg.value(metadata i8* %11, metadata !158, metadata !DIExpression()), !dbg !176
  %18 = getelementptr i8, i8* %10, i64 34, !dbg !178
  %19 = icmp ugt i8* %18, %6, !dbg !180
  br i1 %19, label %53, label %23, !dbg !181

20:                                               ; preds = %13
  call void @llvm.dbg.value(metadata i8* %10, metadata !182, metadata !DIExpression()), !dbg !223
  call void @llvm.dbg.value(metadata i64* undef, metadata !185, metadata !DIExpression()), !dbg !223
  call void @llvm.dbg.value(metadata i8* %6, metadata !186, metadata !DIExpression()), !dbg !223
  call void @llvm.dbg.value(metadata i8* %11, metadata !187, metadata !DIExpression()), !dbg !223
  %21 = getelementptr i8, i8* %10, i64 54, !dbg !226
  %22 = icmp ugt i8* %21, %6, !dbg !228
  br i1 %22, label %53, label %23, !dbg !229

23:                                               ; preds = %20, %17
  %24 = phi i64 [ 23, %17 ], [ 20, %20 ]
  %25 = phi i64 [ 34, %17 ], [ 54, %20 ], !dbg !230
  %26 = getelementptr i8, i8* %10, i64 %24, !dbg !231
  %27 = load i8, i8* %26, align 1, !dbg !231, !tbaa !232
  call void @llvm.dbg.value(metadata i8 %27, metadata !116, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !126
  %28 = icmp eq i8 %27, 17, !dbg !233
  br i1 %28, label %29, label %53, !dbg !234

29:                                               ; preds = %23
  call void @llvm.dbg.value(metadata i64 %25, metadata !113, metadata !DIExpression()), !dbg !126
  call void @llvm.dbg.value(metadata i8* %10, metadata !235, metadata !DIExpression()), !dbg !252
  call void @llvm.dbg.value(metadata i64 %25, metadata !240, metadata !DIExpression()), !dbg !252
  call void @llvm.dbg.value(metadata i8* %6, metadata !241, metadata !DIExpression()), !dbg !252
  %30 = getelementptr i8, i8* %10, i64 %25, !dbg !254
  call void @llvm.dbg.value(metadata i8* %30, metadata !242, metadata !DIExpression()), !dbg !252
  %31 = getelementptr i8, i8* %30, i64 8, !dbg !255
  %32 = icmp ugt i8* %31, %6, !dbg !257
  br i1 %32, label %37, label %33, !dbg !258

33:                                               ; preds = %29
  call void @llvm.dbg.value(metadata i8* %30, metadata !242, metadata !DIExpression()), !dbg !252
  %34 = getelementptr inbounds i8, i8* %30, i64 2, !dbg !259
  %35 = bitcast i8* %34 to i16*, !dbg !259
  %36 = load i16, i16* %35, align 2, !dbg !259, !tbaa !260
  br label %37, !dbg !262

37:                                               ; preds = %29, %33
  %38 = phi i16 [ %36, %33 ], [ 0, %29 ]
  %39 = tail call i16 @llvm.bswap.i16(i16 %38) #3
  call void @llvm.dbg.value(metadata i16 %39, metadata !117, metadata !DIExpression()), !dbg !263
  switch i16 %39, label %53 [
    i16 3000, label %40
    i16 3001, label %48
  ], !dbg !264

40:                                               ; preds = %37
  %41 = bitcast i32* %2 to i8*, !dbg !265
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %41) #3, !dbg !265
  call void @llvm.dbg.value(metadata i32 3000, metadata !121, metadata !DIExpression()), !dbg !266
  store i32 3000, i32* %2, align 4, !dbg !267, !tbaa !268
  call void @llvm.dbg.value(metadata i32* %2, metadata !121, metadata !DIExpression(DW_OP_deref)), !dbg !266
  %42 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @map to i8*), i8* nonnull %41) #3, !dbg !269
  %43 = bitcast i8* %42 to i64*, !dbg !269
  call void @llvm.dbg.value(metadata i64* %43, metadata !124, metadata !DIExpression()), !dbg !266
  %44 = icmp eq i8* %42, null, !dbg !270
  br i1 %44, label %52, label %45, !dbg !272

45:                                               ; preds = %40
  %46 = load i64, i64* %43, align 8, !dbg !273, !tbaa !274
  %47 = add nsw i64 %46, 1, !dbg !273
  store i64 %47, i64* %43, align 8, !dbg !273, !tbaa !274
  br label %52, !dbg !276

48:                                               ; preds = %37
  call void @llvm.dbg.value(metadata i64 %25, metadata !113, metadata !DIExpression()), !dbg !126
  call void @llvm.dbg.value(metadata i8* %10, metadata !277, metadata !DIExpression()), !dbg !286
  call void @llvm.dbg.value(metadata i64 %25, metadata !282, metadata !DIExpression()), !dbg !286
  call void @llvm.dbg.value(metadata i8* %6, metadata !283, metadata !DIExpression()), !dbg !286
  call void @llvm.dbg.value(metadata i32 3000, metadata !284, metadata !DIExpression()), !dbg !286
  call void @llvm.dbg.value(metadata i8* %30, metadata !285, metadata !DIExpression()), !dbg !286
  br i1 %32, label %53, label %49, !dbg !290

49:                                               ; preds = %48
  call void @llvm.dbg.value(metadata i8* %30, metadata !285, metadata !DIExpression()), !dbg !286
  %50 = getelementptr inbounds i8, i8* %30, i64 2, !dbg !291
  %51 = bitcast i8* %50 to i16*, !dbg !291
  store i16 -18421, i16* %51, align 2, !dbg !293, !tbaa !260
  br label %53, !dbg !294

52:                                               ; preds = %40, %45
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %41) #3, !dbg !295
  br label %53

53:                                               ; preds = %37, %13, %48, %49, %20, %17, %23, %52, %1
  %54 = phi i32 [ 1, %52 ], [ 0, %1 ], [ 2, %23 ], [ 2, %17 ], [ 2, %20 ], [ 2, %49 ], [ 2, %48 ], [ 2, %13 ], [ 2, %37 ], !dbg !126
  ret i32 %54, !dbg !296
}

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare i16 @llvm.bswap.i16(i16) #2

attributes #0 = { nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!75, !76, !77, !78}
!llvm.ident = !{!79}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "map", scope: !2, file: !3, line: 8, type: !67, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 13.0.1 (https://github.com/llvm/llvm-project.git 19b8368225dc9ec5a0da547eae48c10dae13522d)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !43, globals: !52, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "prog.bpf.c", directory: "/home/thais/Documents/Master/eBPF/benchmark/programs/dropudp")
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
!14 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !15, line: 40, baseType: !7, size: 32, elements: !16)
!15 = !DIFile(filename: "/usr/include/netinet/in.h", directory: "")
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
!43 = !{!44, !45, !46, !50}
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!45 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !47, line: 26, baseType: !48)
!47 = !DIFile(filename: "/usr/include/bits/stdint-uintn.h", directory: "")
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !49, line: 42, baseType: !7)
!49 = !DIFile(filename: "/usr/include/bits/types.h", directory: "")
!50 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !49, line: 40, baseType: !51)
!51 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!52 = !{!0, !53, !59}
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 132, type: !55, isLocal: false, isDefinition: true)
!55 = !DICompositeType(tag: DW_TAG_array_type, baseType: !56, size: 104, elements: !57)
!56 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!57 = !{!58}
!58 = !DISubrange(count: 13)
!59 = !DIGlobalVariableExpression(var: !60, expr: !DIExpression())
!60 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !61, line: 51, type: !62, isLocal: true, isDefinition: true)
!61 = !DIFile(filename: "../../libs/libbpf/src/root/usr/include/bpf/bpf_helper_defs.h", directory: "/home/thais/Documents/Master/eBPF/benchmark/programs/dropudp")
!62 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !63, size: 64)
!63 = !DISubroutineType(types: !64)
!64 = !{!44, !44, !65}
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !66, size: 64)
!66 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!67 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !68, line: 130, size: 160, elements: !69)
!68 = !DIFile(filename: "../../libs/libbpf/src/root/usr/include/bpf/bpf_helpers.h", directory: "/home/thais/Documents/Master/eBPF/benchmark/programs/dropudp")
!69 = !{!70, !71, !72, !73, !74}
!70 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !67, file: !68, line: 131, baseType: !7, size: 32)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !67, file: !68, line: 132, baseType: !7, size: 32, offset: 32)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !67, file: !68, line: 133, baseType: !7, size: 32, offset: 64)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !67, file: !68, line: 134, baseType: !7, size: 32, offset: 96)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !67, file: !68, line: 135, baseType: !7, size: 32, offset: 128)
!75 = !{i32 7, !"Dwarf Version", i32 4}
!76 = !{i32 2, !"Debug Info Version", i32 3}
!77 = !{i32 1, !"wchar_size", i32 4}
!78 = !{i32 7, !"frame-pointer", i32 2}
!79 = !{!"clang version 13.0.1 (https://github.com/llvm/llvm-project.git 19b8368225dc9ec5a0da547eae48c10dae13522d)"}
!80 = distinct !DISubprogram(name: "dropXDP", scope: !3, file: !3, line: 94, type: !81, scopeLine: 94, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !94)
!81 = !DISubroutineType(types: !82)
!82 = !{!83, !84}
!83 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!84 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !85, size: 64)
!85 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 3161, size: 160, elements: !86)
!86 = !{!87, !90, !91, !92, !93}
!87 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !85, file: !6, line: 3162, baseType: !88, size: 32)
!88 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !89, line: 27, baseType: !7)
!89 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "")
!90 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !85, file: !6, line: 3163, baseType: !88, size: 32, offset: 32)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !85, file: !6, line: 3164, baseType: !88, size: 32, offset: 64)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !85, file: !6, line: 3166, baseType: !88, size: 32, offset: 96)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !85, file: !6, line: 3167, baseType: !88, size: 32, offset: 128)
!94 = !{!95, !96, !97, !98, !113, !116, !117, !121, !124}
!95 = !DILocalVariable(name: "ctx", arg: 1, scope: !80, file: !3, line: 94, type: !84)
!96 = !DILocalVariable(name: "data_end", scope: !80, file: !3, line: 95, type: !44)
!97 = !DILocalVariable(name: "data", scope: !80, file: !3, line: 96, type: !44)
!98 = !DILocalVariable(name: "eth", scope: !80, file: !3, line: 97, type: !99)
!99 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !100, size: 64)
!100 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !101, line: 163, size: 112, elements: !102)
!101 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "")
!102 = !{!103, !108, !109}
!103 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !100, file: !101, line: 164, baseType: !104, size: 48)
!104 = !DICompositeType(tag: DW_TAG_array_type, baseType: !105, size: 48, elements: !106)
!105 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!106 = !{!107}
!107 = !DISubrange(count: 6)
!108 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !100, file: !101, line: 165, baseType: !104, size: 48, offset: 48)
!109 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !100, file: !101, line: 166, baseType: !110, size: 16, offset: 96)
!110 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !111, line: 25, baseType: !112)
!111 = !DIFile(filename: "/usr/include/linux/types.h", directory: "")
!112 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !89, line: 24, baseType: !51)
!113 = !DILocalVariable(name: "nh_off", scope: !80, file: !3, line: 99, type: !114)
!114 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !89, line: 31, baseType: !115)
!115 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!116 = !DILocalVariable(name: "ipproto", scope: !80, file: !3, line: 100, type: !88)
!117 = !DILocalVariable(name: "dest_port", scope: !118, file: !3, line: 114, type: !120)
!118 = distinct !DILexicalBlock(scope: !119, file: !3, line: 113, column: 33)
!119 = distinct !DILexicalBlock(scope: !80, file: !3, line: 113, column: 9)
!120 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !47, line: 25, baseType: !50)
!121 = !DILocalVariable(name: "index", scope: !122, file: !3, line: 117, type: !46)
!122 = distinct !DILexicalBlock(scope: !123, file: !3, line: 116, column: 32)
!123 = distinct !DILexicalBlock(scope: !118, file: !3, line: 116, column: 13)
!124 = !DILocalVariable(name: "value", scope: !122, file: !3, line: 118, type: !125)
!125 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64)
!126 = !DILocation(line: 0, scope: !80)
!127 = !DILocation(line: 95, column: 41, scope: !80)
!128 = !{!129, !130, i64 4}
!129 = !{!"xdp_md", !130, i64 0, !130, i64 4, !130, i64 8, !130, i64 12, !130, i64 16}
!130 = !{!"int", !131, i64 0}
!131 = !{!"omnipotent char", !132, i64 0}
!132 = !{!"Simple C/C++ TBAA"}
!133 = !DILocation(line: 95, column: 30, scope: !80)
!134 = !DILocation(line: 95, column: 22, scope: !80)
!135 = !DILocation(line: 96, column: 37, scope: !80)
!136 = !{!129, !130, i64 0}
!137 = !DILocation(line: 96, column: 26, scope: !80)
!138 = !DILocation(line: 96, column: 18, scope: !80)
!139 = !DILocation(line: 103, column: 14, scope: !140)
!140 = distinct !DILexicalBlock(scope: !80, file: !3, line: 103, column: 9)
!141 = !DILocation(line: 103, column: 23, scope: !140)
!142 = !DILocation(line: 103, column: 9, scope: !80)
!143 = !DILocation(line: 97, column: 26, scope: !80)
!144 = !DILocation(line: 106, column: 14, scope: !145)
!145 = distinct !DILexicalBlock(scope: !80, file: !3, line: 106, column: 9)
!146 = !{!147, !148, i64 12}
!147 = !{!"ethhdr", !131, i64 0, !131, i64 6, !148, i64 12}
!148 = !{!"short", !131, i64 0}
!149 = !DILocation(line: 106, column: 9, scope: !80)
!150 = !DILocalVariable(name: "data", arg: 1, scope: !151, file: !3, line: 58, type: !44)
!151 = distinct !DISubprogram(name: "getProtocolIPv4", scope: !3, file: !3, line: 58, type: !152, scopeLine: 58, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !155)
!152 = !DISubroutineType(types: !153)
!153 = !{!83, !44, !154, !44}
!154 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !114, size: 64)
!155 = !{!150, !156, !157, !158}
!156 = !DILocalVariable(name: "nh_off", arg: 2, scope: !151, file: !3, line: 58, type: !154)
!157 = !DILocalVariable(name: "data_end", arg: 3, scope: !151, file: !3, line: 58, type: !44)
!158 = !DILocalVariable(name: "iph", scope: !151, file: !3, line: 59, type: !159)
!159 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !160, size: 64)
!160 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !161, line: 44, size: 160, elements: !162)
!161 = !DIFile(filename: "/usr/include/netinet/ip.h", directory: "")
!162 = !{!163, !164, !165, !168, !169, !170, !171, !172, !173, !174, !175}
!163 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !160, file: !161, line: 47, baseType: !7, size: 4, flags: DIFlagBitField, extraData: i64 0)
!164 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !160, file: !161, line: 48, baseType: !7, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!165 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !160, file: !161, line: 55, baseType: !166, size: 8, offset: 8)
!166 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !47, line: 24, baseType: !167)
!167 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !49, line: 38, baseType: !105)
!168 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !160, file: !161, line: 56, baseType: !120, size: 16, offset: 16)
!169 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !160, file: !161, line: 57, baseType: !120, size: 16, offset: 32)
!170 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !160, file: !161, line: 58, baseType: !120, size: 16, offset: 48)
!171 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !160, file: !161, line: 59, baseType: !166, size: 8, offset: 64)
!172 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !160, file: !161, line: 60, baseType: !166, size: 8, offset: 72)
!173 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !160, file: !161, line: 61, baseType: !120, size: 16, offset: 80)
!174 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !160, file: !161, line: 62, baseType: !46, size: 32, offset: 96)
!175 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !160, file: !161, line: 63, baseType: !46, size: 32, offset: 128)
!176 = !DILocation(line: 0, scope: !151, inlinedAt: !177)
!177 = distinct !DILocation(line: 107, column: 19, scope: !145)
!178 = !DILocation(line: 62, column: 24, scope: !179, inlinedAt: !177)
!179 = distinct !DILexicalBlock(scope: !151, file: !3, line: 62, column: 9)
!180 = !DILocation(line: 62, column: 47, scope: !179, inlinedAt: !177)
!181 = !DILocation(line: 62, column: 9, scope: !151, inlinedAt: !177)
!182 = !DILocalVariable(name: "data", arg: 1, scope: !183, file: !3, line: 78, type: !44)
!183 = distinct !DISubprogram(name: "getProtocolIPv6", scope: !3, file: !3, line: 78, type: !152, scopeLine: 78, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !184)
!184 = !{!182, !185, !186, !187}
!185 = !DILocalVariable(name: "nh_off", arg: 2, scope: !183, file: !3, line: 78, type: !154)
!186 = !DILocalVariable(name: "data_end", arg: 3, scope: !183, file: !3, line: 78, type: !44)
!187 = !DILocalVariable(name: "ip6h", scope: !183, file: !3, line: 79, type: !188)
!188 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !189, size: 64)
!189 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ipv6hdr", file: !190, line: 116, size: 320, elements: !191)
!190 = !DIFile(filename: "/usr/include/linux/ipv6.h", directory: "")
!191 = !{!192, !194, !195, !199, !200, !201, !202, !222}
!192 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !189, file: !190, line: 118, baseType: !193, size: 4, flags: DIFlagBitField, extraData: i64 0)
!193 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !89, line: 21, baseType: !105)
!194 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !189, file: !190, line: 119, baseType: !193, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!195 = !DIDerivedType(tag: DW_TAG_member, name: "flow_lbl", scope: !189, file: !190, line: 126, baseType: !196, size: 24, offset: 8)
!196 = !DICompositeType(tag: DW_TAG_array_type, baseType: !193, size: 24, elements: !197)
!197 = !{!198}
!198 = !DISubrange(count: 3)
!199 = !DIDerivedType(tag: DW_TAG_member, name: "payload_len", scope: !189, file: !190, line: 128, baseType: !110, size: 16, offset: 32)
!200 = !DIDerivedType(tag: DW_TAG_member, name: "nexthdr", scope: !189, file: !190, line: 129, baseType: !193, size: 8, offset: 48)
!201 = !DIDerivedType(tag: DW_TAG_member, name: "hop_limit", scope: !189, file: !190, line: 130, baseType: !193, size: 8, offset: 56)
!202 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !189, file: !190, line: 132, baseType: !203, size: 128, offset: 64)
!203 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "in6_addr", file: !204, line: 33, size: 128, elements: !205)
!204 = !DIFile(filename: "/usr/include/linux/in6.h", directory: "")
!205 = !{!206}
!206 = !DIDerivedType(tag: DW_TAG_member, name: "in6_u", scope: !203, file: !204, line: 40, baseType: !207, size: 128)
!207 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !203, file: !204, line: 34, size: 128, elements: !208)
!208 = !{!209, !213, !217}
!209 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr8", scope: !207, file: !204, line: 35, baseType: !210, size: 128)
!210 = !DICompositeType(tag: DW_TAG_array_type, baseType: !193, size: 128, elements: !211)
!211 = !{!212}
!212 = !DISubrange(count: 16)
!213 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr16", scope: !207, file: !204, line: 37, baseType: !214, size: 128)
!214 = !DICompositeType(tag: DW_TAG_array_type, baseType: !110, size: 128, elements: !215)
!215 = !{!216}
!216 = !DISubrange(count: 8)
!217 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr32", scope: !207, file: !204, line: 38, baseType: !218, size: 128)
!218 = !DICompositeType(tag: DW_TAG_array_type, baseType: !219, size: 128, elements: !220)
!219 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !111, line: 27, baseType: !88)
!220 = !{!221}
!221 = !DISubrange(count: 4)
!222 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !189, file: !190, line: 133, baseType: !203, size: 128, offset: 192)
!223 = !DILocation(line: 0, scope: !183, inlinedAt: !224)
!224 = distinct !DILocation(line: 109, column: 19, scope: !225)
!225 = distinct !DILexicalBlock(scope: !145, file: !3, line: 108, column: 14)
!226 = !DILocation(line: 82, column: 24, scope: !227, inlinedAt: !224)
!227 = distinct !DILexicalBlock(scope: !183, file: !3, line: 82, column: 9)
!228 = !DILocation(line: 82, column: 49, scope: !227, inlinedAt: !224)
!229 = !DILocation(line: 82, column: 9, scope: !183, inlinedAt: !224)
!230 = !DILocation(line: 99, column: 11, scope: !80)
!231 = !DILocation(line: 0, scope: !145)
!232 = !{!131, !131, i64 0}
!233 = !DILocation(line: 113, column: 17, scope: !119)
!234 = !DILocation(line: 113, column: 9, scope: !80)
!235 = !DILocalVariable(name: "data", arg: 1, scope: !236, file: !3, line: 40, type: !44)
!236 = distinct !DISubprogram(name: "getDestPortUDP", scope: !3, file: !3, line: 40, type: !237, scopeLine: 40, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !239)
!237 = !DISubroutineType(types: !238)
!238 = !{!83, !44, !114, !44}
!239 = !{!235, !240, !241, !242}
!240 = !DILocalVariable(name: "nh_off", arg: 2, scope: !236, file: !3, line: 40, type: !114)
!241 = !DILocalVariable(name: "data_end", arg: 3, scope: !236, file: !3, line: 40, type: !44)
!242 = !DILocalVariable(name: "udph", scope: !236, file: !3, line: 41, type: !243)
!243 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !244, size: 64)
!244 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "udphdr", file: !245, line: 23, size: 64, elements: !246)
!245 = !DIFile(filename: "/usr/include/linux/udp.h", directory: "")
!246 = !{!247, !248, !249, !250}
!247 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !244, file: !245, line: 24, baseType: !110, size: 16)
!248 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !244, file: !245, line: 25, baseType: !110, size: 16, offset: 16)
!249 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !244, file: !245, line: 26, baseType: !110, size: 16, offset: 32)
!250 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !244, file: !245, line: 27, baseType: !251, size: 16, offset: 48)
!251 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !111, line: 31, baseType: !112)
!252 = !DILocation(line: 0, scope: !236, inlinedAt: !253)
!253 = distinct !DILocation(line: 114, column: 30, scope: !118)
!254 = !DILocation(line: 41, column: 32, scope: !236, inlinedAt: !253)
!255 = !DILocation(line: 43, column: 23, scope: !256, inlinedAt: !253)
!256 = distinct !DILexicalBlock(scope: !236, file: !3, line: 43, column: 9)
!257 = !DILocation(line: 43, column: 47, scope: !256, inlinedAt: !253)
!258 = !DILocation(line: 43, column: 9, scope: !236, inlinedAt: !253)
!259 = !DILocation(line: 46, column: 18, scope: !236, inlinedAt: !253)
!260 = !{!261, !148, i64 2}
!261 = !{!"udphdr", !148, i64 0, !148, i64 2, !148, i64 4, !148, i64 6}
!262 = !DILocation(line: 46, column: 5, scope: !236, inlinedAt: !253)
!263 = !DILocation(line: 0, scope: !118)
!264 = !DILocation(line: 116, column: 13, scope: !118)
!265 = !DILocation(line: 117, column: 13, scope: !122)
!266 = !DILocation(line: 0, scope: !122)
!267 = !DILocation(line: 117, column: 22, scope: !122)
!268 = !{!130, !130, i64 0}
!269 = !DILocation(line: 118, column: 27, scope: !122)
!270 = !DILocation(line: 119, column: 17, scope: !271)
!271 = distinct !DILexicalBlock(scope: !122, file: !3, line: 119, column: 17)
!272 = !DILocation(line: 119, column: 17, scope: !122)
!273 = !DILocation(line: 120, column: 24, scope: !271)
!274 = !{!275, !275, i64 0}
!275 = !{!"long", !131, i64 0}
!276 = !DILocation(line: 120, column: 17, scope: !271)
!277 = !DILocalVariable(name: "data", arg: 1, scope: !278, file: !3, line: 24, type: !44)
!278 = distinct !DISubprogram(name: "editDestPortUDP", scope: !3, file: !3, line: 24, type: !279, scopeLine: 24, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !281)
!279 = !DISubroutineType(types: !280)
!280 = !{null, !44, !114, !44, !83}
!281 = !{!277, !282, !283, !284, !285}
!282 = !DILocalVariable(name: "nh_off", arg: 2, scope: !278, file: !3, line: 24, type: !114)
!283 = !DILocalVariable(name: "data_end", arg: 3, scope: !278, file: !3, line: 24, type: !44)
!284 = !DILocalVariable(name: "port", arg: 4, scope: !278, file: !3, line: 24, type: !83)
!285 = !DILocalVariable(name: "udph", scope: !278, file: !3, line: 25, type: !243)
!286 = !DILocation(line: 0, scope: !278, inlinedAt: !287)
!287 = distinct !DILocation(line: 125, column: 13, scope: !288)
!288 = distinct !DILexicalBlock(scope: !289, file: !3, line: 124, column: 37)
!289 = distinct !DILexicalBlock(scope: !123, file: !3, line: 124, column: 18)
!290 = !DILocation(line: 27, column: 9, scope: !278, inlinedAt: !287)
!291 = !DILocation(line: 28, column: 15, scope: !292, inlinedAt: !287)
!292 = distinct !DILexicalBlock(scope: !278, file: !3, line: 27, column: 9)
!293 = !DILocation(line: 28, column: 20, scope: !292, inlinedAt: !287)
!294 = !DILocation(line: 28, column: 9, scope: !292, inlinedAt: !287)
!295 = !DILocation(line: 123, column: 9, scope: !123)
!296 = !DILocation(line: 130, column: 1, scope: !80)
