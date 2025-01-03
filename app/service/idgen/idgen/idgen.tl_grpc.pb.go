//
// WARNING! All changes made in this file will be lost!
// Created from 'scheme.tl' by 'mtprotoc'
//
// Copyright (c) 2024-present,  Teamgram Authors.
//  All rights reserved.
//
// Author: Benqi (wubenqi@gmail.com)

// Code generated by protoc-gen-go-grpc. DO NOT EDIT.
// versions:
// - protoc-gen-go-grpc v1.3.0
// - protoc             v5.26.1
// source: idgen.tl.proto

package idgen

import (
	context "context"
	mtproto "github.com/teamgram/proto/mtproto"
	grpc "google.golang.org/grpc"
	codes "google.golang.org/grpc/codes"
	status "google.golang.org/grpc/status"
)

// This is a compile-time assertion to ensure that this generated file
// is compatible with the grpc package it is being compiled against.
// Requires gRPC-Go v1.32.0 or later.
const _ = grpc.SupportPackageIsVersion7

const (
	RPCIdgen_IdgenNextId_FullMethodName              = "/idgen.RPCIdgen/idgen_nextId"
	RPCIdgen_IdgenNextIds_FullMethodName             = "/idgen.RPCIdgen/idgen_nextIds"
	RPCIdgen_IdgenGetCurrentSeqId_FullMethodName     = "/idgen.RPCIdgen/idgen_getCurrentSeqId"
	RPCIdgen_IdgenSetCurrentSeqId_FullMethodName     = "/idgen.RPCIdgen/idgen_setCurrentSeqId"
	RPCIdgen_IdgenGetNextSeqId_FullMethodName        = "/idgen.RPCIdgen/idgen_getNextSeqId"
	RPCIdgen_IdgenGetNextNSeqId_FullMethodName       = "/idgen.RPCIdgen/idgen_getNextNSeqId"
	RPCIdgen_IdgenGetNextIdValList_FullMethodName    = "/idgen.RPCIdgen/idgen_getNextIdValList"
	RPCIdgen_IdgenGetCurrentSeqIdList_FullMethodName = "/idgen.RPCIdgen/idgen_getCurrentSeqIdList"
)

// RPCIdgenClient is the client API for RPCIdgen service.
//
// For semantics around ctx use and closing/ending streaming RPCs, please refer to https://pkg.go.dev/google.golang.org/grpc/?tab=doc#ClientConn.NewStream.
type RPCIdgenClient interface {
	IdgenNextId(ctx context.Context, in *TLIdgenNextId, opts ...grpc.CallOption) (*mtproto.Int64, error)
	IdgenNextIds(ctx context.Context, in *TLIdgenNextIds, opts ...grpc.CallOption) (*Vector_Long, error)
	IdgenGetCurrentSeqId(ctx context.Context, in *TLIdgenGetCurrentSeqId, opts ...grpc.CallOption) (*mtproto.Int64, error)
	IdgenSetCurrentSeqId(ctx context.Context, in *TLIdgenSetCurrentSeqId, opts ...grpc.CallOption) (*mtproto.Bool, error)
	IdgenGetNextSeqId(ctx context.Context, in *TLIdgenGetNextSeqId, opts ...grpc.CallOption) (*mtproto.Int64, error)
	IdgenGetNextNSeqId(ctx context.Context, in *TLIdgenGetNextNSeqId, opts ...grpc.CallOption) (*mtproto.Int64, error)
	IdgenGetNextIdValList(ctx context.Context, in *TLIdgenGetNextIdValList, opts ...grpc.CallOption) (*Vector_IdVal, error)
	IdgenGetCurrentSeqIdList(ctx context.Context, in *TLIdgenGetCurrentSeqIdList, opts ...grpc.CallOption) (*Vector_IdVal, error)
}

type rPCIdgenClient struct {
	cc grpc.ClientConnInterface
}

func NewRPCIdgenClient(cc grpc.ClientConnInterface) RPCIdgenClient {
	return &rPCIdgenClient{cc}
}

func (c *rPCIdgenClient) IdgenNextId(ctx context.Context, in *TLIdgenNextId, opts ...grpc.CallOption) (*mtproto.Int64, error) {
	out := new(mtproto.Int64)
	err := c.cc.Invoke(ctx, RPCIdgen_IdgenNextId_FullMethodName, in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *rPCIdgenClient) IdgenNextIds(ctx context.Context, in *TLIdgenNextIds, opts ...grpc.CallOption) (*Vector_Long, error) {
	out := new(Vector_Long)
	err := c.cc.Invoke(ctx, RPCIdgen_IdgenNextIds_FullMethodName, in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *rPCIdgenClient) IdgenGetCurrentSeqId(ctx context.Context, in *TLIdgenGetCurrentSeqId, opts ...grpc.CallOption) (*mtproto.Int64, error) {
	out := new(mtproto.Int64)
	err := c.cc.Invoke(ctx, RPCIdgen_IdgenGetCurrentSeqId_FullMethodName, in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *rPCIdgenClient) IdgenSetCurrentSeqId(ctx context.Context, in *TLIdgenSetCurrentSeqId, opts ...grpc.CallOption) (*mtproto.Bool, error) {
	out := new(mtproto.Bool)
	err := c.cc.Invoke(ctx, RPCIdgen_IdgenSetCurrentSeqId_FullMethodName, in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *rPCIdgenClient) IdgenGetNextSeqId(ctx context.Context, in *TLIdgenGetNextSeqId, opts ...grpc.CallOption) (*mtproto.Int64, error) {
	out := new(mtproto.Int64)
	err := c.cc.Invoke(ctx, RPCIdgen_IdgenGetNextSeqId_FullMethodName, in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *rPCIdgenClient) IdgenGetNextNSeqId(ctx context.Context, in *TLIdgenGetNextNSeqId, opts ...grpc.CallOption) (*mtproto.Int64, error) {
	out := new(mtproto.Int64)
	err := c.cc.Invoke(ctx, RPCIdgen_IdgenGetNextNSeqId_FullMethodName, in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *rPCIdgenClient) IdgenGetNextIdValList(ctx context.Context, in *TLIdgenGetNextIdValList, opts ...grpc.CallOption) (*Vector_IdVal, error) {
	out := new(Vector_IdVal)
	err := c.cc.Invoke(ctx, RPCIdgen_IdgenGetNextIdValList_FullMethodName, in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *rPCIdgenClient) IdgenGetCurrentSeqIdList(ctx context.Context, in *TLIdgenGetCurrentSeqIdList, opts ...grpc.CallOption) (*Vector_IdVal, error) {
	out := new(Vector_IdVal)
	err := c.cc.Invoke(ctx, RPCIdgen_IdgenGetCurrentSeqIdList_FullMethodName, in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

// RPCIdgenServer is the server API for RPCIdgen service.
// All implementations should embed UnimplementedRPCIdgenServer
// for forward compatibility
type RPCIdgenServer interface {
	IdgenNextId(context.Context, *TLIdgenNextId) (*mtproto.Int64, error)
	IdgenNextIds(context.Context, *TLIdgenNextIds) (*Vector_Long, error)
	IdgenGetCurrentSeqId(context.Context, *TLIdgenGetCurrentSeqId) (*mtproto.Int64, error)
	IdgenSetCurrentSeqId(context.Context, *TLIdgenSetCurrentSeqId) (*mtproto.Bool, error)
	IdgenGetNextSeqId(context.Context, *TLIdgenGetNextSeqId) (*mtproto.Int64, error)
	IdgenGetNextNSeqId(context.Context, *TLIdgenGetNextNSeqId) (*mtproto.Int64, error)
	IdgenGetNextIdValList(context.Context, *TLIdgenGetNextIdValList) (*Vector_IdVal, error)
	IdgenGetCurrentSeqIdList(context.Context, *TLIdgenGetCurrentSeqIdList) (*Vector_IdVal, error)
}

// UnimplementedRPCIdgenServer should be embedded to have forward compatible implementations.
type UnimplementedRPCIdgenServer struct {
}

func (UnimplementedRPCIdgenServer) IdgenNextId(context.Context, *TLIdgenNextId) (*mtproto.Int64, error) {
	return nil, status.Errorf(codes.Unimplemented, "method IdgenNextId not implemented")
}
func (UnimplementedRPCIdgenServer) IdgenNextIds(context.Context, *TLIdgenNextIds) (*Vector_Long, error) {
	return nil, status.Errorf(codes.Unimplemented, "method IdgenNextIds not implemented")
}
func (UnimplementedRPCIdgenServer) IdgenGetCurrentSeqId(context.Context, *TLIdgenGetCurrentSeqId) (*mtproto.Int64, error) {
	return nil, status.Errorf(codes.Unimplemented, "method IdgenGetCurrentSeqId not implemented")
}
func (UnimplementedRPCIdgenServer) IdgenSetCurrentSeqId(context.Context, *TLIdgenSetCurrentSeqId) (*mtproto.Bool, error) {
	return nil, status.Errorf(codes.Unimplemented, "method IdgenSetCurrentSeqId not implemented")
}
func (UnimplementedRPCIdgenServer) IdgenGetNextSeqId(context.Context, *TLIdgenGetNextSeqId) (*mtproto.Int64, error) {
	return nil, status.Errorf(codes.Unimplemented, "method IdgenGetNextSeqId not implemented")
}
func (UnimplementedRPCIdgenServer) IdgenGetNextNSeqId(context.Context, *TLIdgenGetNextNSeqId) (*mtproto.Int64, error) {
	return nil, status.Errorf(codes.Unimplemented, "method IdgenGetNextNSeqId not implemented")
}
func (UnimplementedRPCIdgenServer) IdgenGetNextIdValList(context.Context, *TLIdgenGetNextIdValList) (*Vector_IdVal, error) {
	return nil, status.Errorf(codes.Unimplemented, "method IdgenGetNextIdValList not implemented")
}
func (UnimplementedRPCIdgenServer) IdgenGetCurrentSeqIdList(context.Context, *TLIdgenGetCurrentSeqIdList) (*Vector_IdVal, error) {
	return nil, status.Errorf(codes.Unimplemented, "method IdgenGetCurrentSeqIdList not implemented")
}

// UnsafeRPCIdgenServer may be embedded to opt out of forward compatibility for this service.
// Use of this interface is not recommended, as added methods to RPCIdgenServer will
// result in compilation error_types.
type UnsafeRPCIdgenServer interface {
	mustEmbedUnimplementedRPCIdgenServer()
}

func RegisterRPCIdgenServer(s grpc.ServiceRegistrar, srv RPCIdgenServer) {
	s.RegisterService(&RPCIdgen_ServiceDesc, srv)
}

func _RPCIdgen_IdgenNextId_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(TLIdgenNextId)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(RPCIdgenServer).IdgenNextId(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: RPCIdgen_IdgenNextId_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(RPCIdgenServer).IdgenNextId(ctx, req.(*TLIdgenNextId))
	}
	return interceptor(ctx, in, info, handler)
}

func _RPCIdgen_IdgenNextIds_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(TLIdgenNextIds)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(RPCIdgenServer).IdgenNextIds(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: RPCIdgen_IdgenNextIds_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(RPCIdgenServer).IdgenNextIds(ctx, req.(*TLIdgenNextIds))
	}
	return interceptor(ctx, in, info, handler)
}

func _RPCIdgen_IdgenGetCurrentSeqId_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(TLIdgenGetCurrentSeqId)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(RPCIdgenServer).IdgenGetCurrentSeqId(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: RPCIdgen_IdgenGetCurrentSeqId_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(RPCIdgenServer).IdgenGetCurrentSeqId(ctx, req.(*TLIdgenGetCurrentSeqId))
	}
	return interceptor(ctx, in, info, handler)
}

func _RPCIdgen_IdgenSetCurrentSeqId_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(TLIdgenSetCurrentSeqId)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(RPCIdgenServer).IdgenSetCurrentSeqId(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: RPCIdgen_IdgenSetCurrentSeqId_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(RPCIdgenServer).IdgenSetCurrentSeqId(ctx, req.(*TLIdgenSetCurrentSeqId))
	}
	return interceptor(ctx, in, info, handler)
}

func _RPCIdgen_IdgenGetNextSeqId_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(TLIdgenGetNextSeqId)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(RPCIdgenServer).IdgenGetNextSeqId(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: RPCIdgen_IdgenGetNextSeqId_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(RPCIdgenServer).IdgenGetNextSeqId(ctx, req.(*TLIdgenGetNextSeqId))
	}
	return interceptor(ctx, in, info, handler)
}

func _RPCIdgen_IdgenGetNextNSeqId_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(TLIdgenGetNextNSeqId)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(RPCIdgenServer).IdgenGetNextNSeqId(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: RPCIdgen_IdgenGetNextNSeqId_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(RPCIdgenServer).IdgenGetNextNSeqId(ctx, req.(*TLIdgenGetNextNSeqId))
	}
	return interceptor(ctx, in, info, handler)
}

func _RPCIdgen_IdgenGetNextIdValList_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(TLIdgenGetNextIdValList)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(RPCIdgenServer).IdgenGetNextIdValList(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: RPCIdgen_IdgenGetNextIdValList_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(RPCIdgenServer).IdgenGetNextIdValList(ctx, req.(*TLIdgenGetNextIdValList))
	}
	return interceptor(ctx, in, info, handler)
}

func _RPCIdgen_IdgenGetCurrentSeqIdList_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(TLIdgenGetCurrentSeqIdList)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(RPCIdgenServer).IdgenGetCurrentSeqIdList(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: RPCIdgen_IdgenGetCurrentSeqIdList_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(RPCIdgenServer).IdgenGetCurrentSeqIdList(ctx, req.(*TLIdgenGetCurrentSeqIdList))
	}
	return interceptor(ctx, in, info, handler)
}

// RPCIdgen_ServiceDesc is the grpc.ServiceDesc for RPCIdgen service.
// It's only intended for direct use with grpc.RegisterService,
// and not to be introspected or modified (even as a copy)
var RPCIdgen_ServiceDesc = grpc.ServiceDesc{
	ServiceName: "idgen.RPCIdgen",
	HandlerType: (*RPCIdgenServer)(nil),
	Methods: []grpc.MethodDesc{
		{
			MethodName: "idgen_nextId",
			Handler:    _RPCIdgen_IdgenNextId_Handler,
		},
		{
			MethodName: "idgen_nextIds",
			Handler:    _RPCIdgen_IdgenNextIds_Handler,
		},
		{
			MethodName: "idgen_getCurrentSeqId",
			Handler:    _RPCIdgen_IdgenGetCurrentSeqId_Handler,
		},
		{
			MethodName: "idgen_setCurrentSeqId",
			Handler:    _RPCIdgen_IdgenSetCurrentSeqId_Handler,
		},
		{
			MethodName: "idgen_getNextSeqId",
			Handler:    _RPCIdgen_IdgenGetNextSeqId_Handler,
		},
		{
			MethodName: "idgen_getNextNSeqId",
			Handler:    _RPCIdgen_IdgenGetNextNSeqId_Handler,
		},
		{
			MethodName: "idgen_getNextIdValList",
			Handler:    _RPCIdgen_IdgenGetNextIdValList_Handler,
		},
		{
			MethodName: "idgen_getCurrentSeqIdList",
			Handler:    _RPCIdgen_IdgenGetCurrentSeqIdList_Handler,
		},
	},
	Streams:  []grpc.StreamDesc{},
	Metadata: "idgen.tl.proto",
}
