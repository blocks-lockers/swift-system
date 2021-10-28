/*
 This source file is part of the Swift System open source project

 Copyright (c) 2020 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
import Darwin
#elseif os(Linux) || os(FreeBSD) || os(Android)
import Glibc
#elseif os(Windows)
import ucrt
#else
#error("Unsupported Platform")
#endif

// Interacting with the mocking system, tracing, etc., is a potentially significant
// amount of code size, so we hand outline that code for every syscall

@usableFromInline
internal func system_getpid() -> CInterop.ProcessID {
#if ENABLE_MOCKING
  if mockingEnabled {
    return _mock()
  }
#endif
  return getpid()
}

@usableFromInline
internal func system_getppid() -> CInterop.ProcessID {
#if ENABLE_MOCKING
  if mockingEnabled {
    return _mock()
  }
#endif
  return getppid()
}

@usableFromInline
internal func system_getpagesize() -> Int32 {
#if ENABLE_MOCKING
  if mockingEnabled {
    return _mock()
  }
#endif
  return getpagesize()
}

@usableFromInline
internal func system_getdtablesize() -> Int32 {
#if ENABLE_MOCKING
  if mockingEnabled {
    return _mock()
  }
#endif
  return getdtablesize()
}

internal func system_strcpy(_ destination: UnsafeMutablePointer<CChar>, _ source: UnsafePointer<CChar>) -> UnsafeMutablePointer<CChar> {
  #if ENABLE_MOCKING
  // FIXME
  #endif
  return strcpy(destination, source)
}

// open
internal func system_open(
  _ path: UnsafePointer<CInterop.PlatformChar>, _ oflag: Int32
) -> CInt {
#if ENABLE_MOCKING
  if mockingEnabled {
    return _mock(path: path, oflag)
  }
#endif
  return open(path, oflag)
}

internal func system_open(
  _ path: UnsafePointer<CInterop.PlatformChar>,
  _ oflag: Int32, _ mode: CInterop.Mode
) -> CInt {
#if ENABLE_MOCKING
  if mockingEnabled {
    return _mock(path: path, oflag, mode)
  }
#endif
  return open(path, oflag, mode)
}

// close
internal func system_close(_ fd: Int32) -> Int32 {
#if ENABLE_MOCKING
  if mockingEnabled { return _mock(fd) }
#endif
  return close(fd)
}

// read
internal func system_read(
  _ fd: Int32, _ buf: UnsafeMutableRawPointer!, _ nbyte: Int
) -> Int {
#if ENABLE_MOCKING
  if mockingEnabled { return _mockInt(fd, buf, nbyte) }
#endif
  return read(fd, buf, nbyte)
}

// pread
internal func system_pread(
  _ fd: Int32, _ buf: UnsafeMutableRawPointer!, _ nbyte: Int, _ offset: off_t
) -> Int {
#if ENABLE_MOCKING
  if mockingEnabled { return _mockInt(fd, buf, nbyte, offset) }
#endif
  return pread(fd, buf, nbyte, offset)
}

// lseek
internal func system_lseek(
  _ fd: Int32, _ off: off_t, _ whence: Int32
) -> off_t {
#if ENABLE_MOCKING
  if mockingEnabled { return _mockOffT(fd, off, whence) }
#endif
  return lseek(fd, off, whence)
}

// write
internal func system_write(
  _ fd: Int32, _ buf: UnsafeRawPointer!, _ nbyte: Int
) -> Int {
#if ENABLE_MOCKING
  if mockingEnabled { return _mockInt(fd, buf, nbyte) }
#endif
  return write(fd, buf, nbyte)
}

// pwrite
internal func system_pwrite(
  _ fd: Int32, _ buf: UnsafeRawPointer!, _ nbyte: Int, _ offset: off_t
) -> Int {
#if ENABLE_MOCKING
  if mockingEnabled { return _mockInt(fd, buf, nbyte, offset) }
#endif
  return pwrite(fd, buf, nbyte, offset)
}

internal func system_dup(_ fd: Int32) -> Int32 {
  #if ENABLE_MOCKING
  if mockingEnabled { return _mock(fd) }
  #endif
  return dup(fd)
}

internal func system_dup2(_ fd: Int32, _ fd2: Int32) -> Int32 {
  #if ENABLE_MOCKING
  if mockingEnabled { return _mock(fd, fd2) }
  #endif
  return dup2(fd, fd2)
}

internal func system_inet_pton(
    _ family: Int32,
    _ cString: UnsafePointer<CInterop.PlatformChar>,
    _ address: UnsafeMutableRawPointer) -> Int32 {
  #if ENABLE_MOCKING
  if mockingEnabled { return _mock(family, cString, address) }
  #endif
  return inet_pton(family, cString, address)
}

internal func system_inet_ntop(_ family: Int32, _ pointer : UnsafeRawPointer, _ string: UnsafeMutablePointer<CChar>, _ length: UInt32) -> UnsafePointer<CChar>? {
  #if ENABLE_MOCKING
  //if mockingEnabled { return _mock(family, pointer, string, length) }
  #endif
  return inet_ntop(family, pointer, string, length)
}

internal func system_socket(_ fd: Int32, _ fd2: Int32, _ fd3: Int32) -> Int32 {
  #if ENABLE_MOCKING
  if mockingEnabled { return _mock(fd, fd2, fd3) }
  #endif
  return socket(fd, fd2, fd3)
}

internal func system_setsockopt(_ fd: Int32, _ fd2: Int32, _ fd3: Int32, _ pointer: UnsafeRawPointer, _ dataLength: UInt32) -> Int32 {
  #if ENABLE_MOCKING
  if mockingEnabled { return _mock(fd, fd2, fd3, pointer, dataLength) }
  #endif
  return setsockopt(fd, fd2, fd3, pointer, dataLength)
}

internal func system_getsockopt(
  _ socket: CInt,
  _ level: CInt,
  _ option: CInt,
  _ value: UnsafeMutableRawPointer?,
  _ length: UnsafeMutablePointer<UInt32>?
) -> CInt {
  #if ENABLE_MOCKING
  if mockingEnabled { return _mock(socket, level, option, value, length) }
  #endif
  return getsockopt(socket, level, option, value, length)
}

internal func system_bind(
    _ socket: CInt,
    _ address: UnsafePointer<CInterop.SocketAddress>,
    _ length: UInt32
) -> CInt {
  #if ENABLE_MOCKING
  if mockingEnabled { return _mock(socket, address, length) }
  #endif
  return bind(socket, address, length)
}

internal func system_connect(
  _ socket: CInt,
  _ addr: UnsafePointer<sockaddr>?,
  _ len: socklen_t
) -> CInt {
  #if ENABLE_MOCKING
  if mockingEnabled { return _mock(socket, addr, len) }
  #endif
  return connect(socket, addr, len)
}

internal func system_accept(
  _ socket: CInt,
  _ addr: UnsafeMutablePointer<sockaddr>?,
  _ len: UnsafeMutablePointer<socklen_t>?
) -> CInt {
  #if ENABLE_MOCKING
  if mockingEnabled { return _mock(socket, addr, len) }
  #endif
  return accept(socket, addr, len)
}

internal func system_getaddrinfo(
  _ hostname: UnsafePointer<CChar>?,
  _ servname: UnsafePointer<CChar>?,
  _ hints: UnsafePointer<CInterop.AddressInfo>?,
  _ res: UnsafeMutablePointer<UnsafeMutablePointer<CInterop.AddressInfo>?>?
) -> CInt {
  #if ENABLE_MOCKING
  if mockingEnabled {
    return _mock(hostname,
                 servname,
                 hints, res)
  }
  #endif
  return getaddrinfo(hostname, servname, hints, res)
}

internal func system_getnameinfo(
  _ sa: UnsafePointer<CInterop.SocketAddress>?,
  _ salen: UInt32,
  _ host: UnsafeMutablePointer<CChar>?,
  _ hostlen: UInt32,
  _ serv: UnsafeMutablePointer<CChar>?,
  _ servlen: UInt32,
  _ flags: CInt
) -> CInt {
  #if ENABLE_MOCKING
  if mockingEnabled {
    return _mock(sa, salen, host, hostlen, serv, servlen, flags)
  }
  #endif
  return getnameinfo(sa, salen, host, hostlen, serv, servlen, flags)
}

internal func system_freeaddrinfo(
  _ addrinfo: UnsafeMutablePointer<CInterop.AddressInfo>?
) {
  #if ENABLE_MOCKING
  if mockingEnabled {
    _ = _mock(addrinfo)
    return
  }
  #endif
  return freeaddrinfo(addrinfo)
}

internal func system_gai_strerror(_ error: CInt) -> UnsafePointer<CChar> {
  #if ENABLE_MOCKING
  // FIXME
  #endif
  return gai_strerror(error)
}

internal func system_shutdown(_ socket: CInt, _ how: CInt) -> CInt {
  #if ENABLE_MOCKING
  if mockingEnabled { return _mock(socket, how) }
  #endif
  return shutdown(socket, how)
}

internal func system_listen(_ socket: CInt, _ backlog: CInt) -> CInt {
  #if ENABLE_MOCKING
  if mockingEnabled { return _mock(socket, backlog) }
  #endif
  return listen(socket, backlog)
}

internal func system_send(
  _ socket: Int32, _ buffer: UnsafeRawPointer?, _ len: Int, _ flags: Int32
) -> Int {
  #if ENABLE_MOCKING
  if mockingEnabled { return _mockInt(socket, buffer, len, flags) }
  #endif
  return send(socket, buffer, len, flags)
}

internal func system_recv(
  _ socket: Int32,
  _ buffer: UnsafeMutableRawPointer?,
  _ len: Int,
  _ flags: Int32
) -> Int {
  #if ENABLE_MOCKING
  if mockingEnabled { return _mockInt(socket, buffer, len, flags) }
  #endif
  return recv(socket, buffer, len, flags)
}

internal func system_sendto(
  _ socket: CInt,
  _ buffer: UnsafeRawPointer?,
  _ length: Int,
  _ flags: CInt,
  _ dest_addr: UnsafePointer<CInterop.SocketAddress>?,
  _ dest_len: UInt32
) -> Int {
  #if ENABLE_MOCKING
  if mockingEnabled {
    return _mockInt(socket, buffer, length, flags, dest_addr, dest_len)
  }
  #endif
  return sendto(socket, buffer, length, flags, dest_addr, dest_len)
}

internal func system_recvfrom(
  _ socket: CInt,
  _ buffer: UnsafeMutableRawPointer?,
  _ length: Int,
  _ flags: CInt,
  _ address: UnsafeMutablePointer<CInterop.SocketAddress>?,
  _ addres_len: UnsafeMutablePointer<UInt32>?
) -> Int {
  #if ENABLE_MOCKING
  if mockingEnabled {
    return _mockInt(socket, buffer, length, flags, address, addres_len)
  }
  #endif
  return recvfrom(socket, buffer, length, flags, address, addres_len)
}

internal func system_poll(
    _ fileDescriptors: UnsafeMutablePointer<CInterop.PollFileDescriptor>,
    _ fileDescriptorsCount: CInterop.FileDescriptorCount,
    _ timeout: CInt
) -> CInt {
  #if ENABLE_MOCKING
  if mockingEnabled { return _mock(fileDescriptors, fileDescriptorsCount, timeout) }
  #endif
  return poll(fileDescriptors, fileDescriptorsCount, timeout)
}

internal func system_sendmsg(
  _ socket: CInt,
  _ message: UnsafePointer<CInterop.MessageHeader>?,
  _ flags: CInt
) -> Int {
  #if ENABLE_MOCKING
  if mockingEnabled { return _mockInt(socket, message, flags) }
  #endif
  return sendmsg(socket, message, flags)
}

internal func system_recvmsg(
  _ socket: CInt,
  _ message: UnsafeMutablePointer<CInterop.MessageHeader>?,
  _ flags: CInt
) -> Int {
  #if ENABLE_MOCKING
  if mockingEnabled { return _mockInt(socket, message, flags) }
  #endif
  return recvmsg(socket, message, flags)
}

// ioctl
internal func system_ioctl(
  _ fd: Int32,
  _ request: CUnsignedLong
) -> CInt {
#if ENABLE_MOCKING
  if mockingEnabled { return _mock(fd, request) }
#endif
  return ioctl(fd, request)
}

// ioctl
internal func system_ioctl(
  _ fd: Int32,
  _ request: CUnsignedLong,
  _ value: CInt
) -> CInt {
#if ENABLE_MOCKING
  if mockingEnabled { return _mock(fd, request, value) }
#endif
  return ioctl(fd, request, value)
}

// ioctl
internal func system_ioctl(
  _ fd: Int32,
  _ request: CUnsignedLong,
  _ pointer: UnsafeMutableRawPointer
) -> CInt {
#if ENABLE_MOCKING
  if mockingEnabled { return _mock(fd, request, pointer) }
#endif
  return ioctl(fd, request, pointer)
}

#if !os(Windows)
internal func system_pipe(_ fds: UnsafeMutablePointer<Int32>) -> CInt {
#if ENABLE_MOCKING
  if mockingEnabled { return _mock(fds) }
#endif
  return pipe(fds)
}
#endif

internal func system_fcntl(
  _ fd: Int32,
  _ cmd: Int32
) -> CInt {
#if ENABLE_MOCKING
  if mockingEnabled { return _mock(fd, cmd) }
#endif
  return fcntl(fd, cmd)
}

internal func system_fcntl(
  _ fd: Int32,
  _ cmd: Int32,
  _ value: Int32
) -> CInt {
#if ENABLE_MOCKING
  if mockingEnabled { return _mock(fd, cmd, value) }
#endif
  return fcntl(fd, cmd, value)
}

internal func system_fcntl(
  _ fd: Int32,
  _ cmd: Int32,
  _ pointer: UnsafeMutableRawPointer
) -> CInt {
#if ENABLE_MOCKING
  if mockingEnabled { return _mock(fd, cmd, pointer) }
#endif
  return fcntl(fd, cmd, pointer)
}

internal func system_sigaddset(
    _ set: UnsafeMutablePointer<CInterop.SignalSet>,
    _ signal: Int32
) -> CInt {
#if ENABLE_MOCKING
  if mockingEnabled { return _mock(set, signal) }
#endif
  return sigaddset(set, signal)
}

internal func system_sigdelset(
    _ set: UnsafeMutablePointer<CInterop.SignalSet>,
    _ signal: Int32
) -> CInt {
#if ENABLE_MOCKING
  if mockingEnabled { return _mock(set, signal) }
#endif
  return sigdelset(set, signal)
}

internal func system_sigismember(
    _ set: UnsafeMutablePointer<CInterop.SignalSet>,
    _ signal: Int32
) -> CInt {
#if ENABLE_MOCKING
  if mockingEnabled { return _mock(set, signal) }
#endif
  return sigismember(set, signal)
}

@discardableResult
internal func system_sigemptyset(
    _ set: UnsafeMutablePointer<CInterop.SignalSet>
) -> CInt {
#if ENABLE_MOCKING
  if mockingEnabled { return _mock(set) }
#endif
  return sigemptyset(set) // always returns 0.
}

@discardableResult
internal func system_sigfillset(
    _ set: UnsafeMutablePointer<CInterop.SignalSet>
) -> CInt {
#if ENABLE_MOCKING
  if mockingEnabled { return _mock(set) }
#endif
  return sigfillset(set) // always returns 0.
}
