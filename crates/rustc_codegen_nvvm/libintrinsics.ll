; This is a hand-written llvm ir module which contains extra functions
; that are easier to write. They mostly contain nvvm intrinsics that are wrapped in new 
; functions so that rustc does not think they are llvm intrinsics and so you don't need to always use nightly for that.
;
; if you update this make sure to update libintrinsics.bc by running llvm-as (make sure you are using llvm-7 or it won't work when
; loaded into libnvvm).
source_filename = "libintrinsics"
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v16:16:16-v32:32:32-v64:64:64-v128:128:128-n16:32:64"
target triple = "nvptx64-nvidia-cuda"

; thread ----

define i32 @__nvvm_thread_idx_x() #0 {
start:
  %0 = call i32 @llvm.nvvm.read.ptx.sreg.tid.x()
  ret i32 %0
}

define i32 @__nvvm_thread_idx_y() #0 {
start:
  %0 = call i32 @llvm.nvvm.read.ptx.sreg.tid.y()
  ret i32 %0
}

define i32 @__nvvm_thread_idx_z() #0 {
start:
  %0 = call i32 @llvm.nvvm.read.ptx.sreg.tid.z()
  ret i32 %0
}

; block dimension ----

define i32 @__nvvm_block_dim_x() #0 {
start:
  %0 = call i32 @llvm.nvvm.read.ptx.sreg.ntid.x()
  ret i32 %0
}

define i32 @__nvvm_block_dim_y() #0 {
start:
  %0 = call i32 @llvm.nvvm.read.ptx.sreg.ntid.y()
  ret i32 %0
}

define i32 @__nvvm_block_dim_z() #0 {
start:
  %0 = call i32 @llvm.nvvm.read.ptx.sreg.ntid.z()
  ret i32 %0
}

; block idx ----

define i32 @__nvvm_block_idx_x() #0 {
start:
  %0 = call i32 @llvm.nvvm.read.ptx.sreg.ctaid.x()
  ret i32 %0
}

define i32 @__nvvm_block_idx_y() #0 {
start:
  %0 = call i32 @llvm.nvvm.read.ptx.sreg.ctaid.y()
  ret i32 %0
}

define i32 @__nvvm_block_idx_z() #0 {
start:
  %0 = call i32 @llvm.nvvm.read.ptx.sreg.ctaid.z()
  ret i32 %0
}

; grid dimension ---- 

define i32 @__nvvm_grid_dim_x() #0 {
start:
  %0 = call i32 @llvm.nvvm.read.ptx.sreg.nctaid.x()
  ret i32 %0
}

define i32 @__nvvm_grid_dim_y() #0 {
start:
  %0 = call i32 @llvm.nvvm.read.ptx.sreg.nctaid.y()
  ret i32 %0
}

define i32 @__nvvm_grid_dim_z() #0 {
start:
  %0 = call i32 @llvm.nvvm.read.ptx.sreg.nctaid.z()
  ret i32 %0
}

; warp ----

define i32 @__nvvm_warp_size() #0 {
start:
  %0 = call i32 @llvm.nvvm.read.ptx.sreg.warpsize()
  ret i32 %0
}

declare i32 @llvm.nvvm.read.ptx.sreg.tid.x()
declare i32 @llvm.nvvm.read.ptx.sreg.tid.y()
declare i32 @llvm.nvvm.read.ptx.sreg.tid.z()
declare i32 @llvm.nvvm.read.ptx.sreg.ntid.x()
declare i32 @llvm.nvvm.read.ptx.sreg.ntid.y()
declare i32 @llvm.nvvm.read.ptx.sreg.ntid.z()
declare i32 @llvm.nvvm.read.ptx.sreg.ctaid.x()
declare i32 @llvm.nvvm.read.ptx.sreg.ctaid.y()
declare i32 @llvm.nvvm.read.ptx.sreg.ctaid.z()
declare i32 @llvm.nvvm.read.ptx.sreg.nctaid.x()
declare i32 @llvm.nvvm.read.ptx.sreg.nctaid.y()
declare i32 @llvm.nvvm.read.ptx.sreg.nctaid.z()
declare i32 @llvm.nvvm.read.ptx.sreg.warpsize()

; other ----

define void @__nvvm_block_barrier() #1 {
start:
  call void @llvm.nvvm.barrier0()
  ret void
}

declare void @llvm.nvvm.barrier0()

define void @__nvvm_grid_fence() #1 {
start:
  call void @llvm.nvvm.membar.cta()
  ret void
}

declare void @llvm.nvvm.membar.cta()

define void @__nvvm_device_fence() #1 {
start:
  call void @llvm.nvvm.membar.gl()
  ret void
}

declare void @llvm.nvvm.membar.gl()

define void @__nvvm_system_fence() #1 {
start:
  call void @llvm.nvvm.membar.sys()
  ret void
}

declare void @llvm.nvvm.membar.sys()

define void @__nvvm_trap() #1 {
start:
  call void @llvm.trap()
  unreachable
  ret void
}

declare void @llvm.trap()

; math stuff -------------

define {i8, i1} @__nvvm_i8_addo(i8, i8) #0 {
start:
  %2 = sext i8 %0 to i16
  %3 = sext i8 %1 to i16
  %4 = call {i16, i1} @llvm.sadd.with.overflow.i16(i16 %2, i16 %3)
  %5 = extractvalue {i16, i1} %4, 0
  %6 = extractvalue {i16, i1} %4, 1
  %7 = trunc i16 %5 to i8
  %8 = insertvalue {i8, i1} undef, i8 %7, 0
  %9 = insertvalue {i8, i1} %8, i1 %6, 1
  ret {i8, i1} %9
}
declare {i16, i1} @llvm.sadd.with.overflow.i16(i16, i16) #0

define {i8, i1} @__nvvm_u8_addo(i8, i8) #0 {
start:
  %2 = sext i8 %0 to i16
  %3 = sext i8 %1 to i16
  %4 = call {i16, i1} @llvm.uadd.with.overflow.i16(i16 %2, i16 %3)
  %5 = extractvalue {i16, i1} %4, 0
  %6 = extractvalue {i16, i1} %4, 1
  %7 = trunc i16 %5 to i8
  %8 = insertvalue {i8, i1} undef, i8 %7, 0
  %9 = insertvalue {i8, i1} %8, i1 %6, 1
  ret {i8, i1} %9
}
declare {i16, i1} @llvm.uadd.with.overflow.i16(i16, i16) #0

define {i8, i1} @__nvvm_i8_subo(i8, i8) #0 {
start:
  %2 = sext i8 %0 to i16
  %3 = sext i8 %1 to i16
  %4 = call {i16, i1} @llvm.ssub.with.overflow.i16(i16 %2, i16 %3)
  %5 = extractvalue {i16, i1} %4, 0
  %6 = extractvalue {i16, i1} %4, 1
  %7 = trunc i16 %5 to i8
  %8 = insertvalue {i8, i1} undef, i8 %7, 0
  %9 = insertvalue {i8, i1} %8, i1 %6, 1
  ret {i8, i1} %9
}
declare {i16, i1} @llvm.ssub.with.overflow.i16(i16, i16) #0

define {i8, i1} @__nvvm_u8_subo(i8, i8) #0 {
start:
  %2 = sext i8 %0 to i16
  %3 = sext i8 %1 to i16
  %4 = call {i16, i1} @llvm.usub.with.overflow.i16(i16 %2, i16 %3)
  %5 = extractvalue {i16, i1} %4, 0
  %6 = extractvalue {i16, i1} %4, 1
  %7 = trunc i16 %5 to i8
  %8 = insertvalue {i8, i1} undef, i8 %7, 0
  %9 = insertvalue {i8, i1} %8, i1 %6, 1
  ret {i8, i1} %9
}
declare {i16, i1} @llvm.usub.with.overflow.i16(i16, i16) #0

define {i8, i1} @__nvvm_i8_mulo(i8, i8) #0 {
start:
  %2 = sext i8 %0 to i16
  %3 = sext i8 %1 to i16
  %4 = call {i16, i1} @llvm.smul.with.overflow.i16(i16 %2, i16 %3)
  %5 = extractvalue {i16, i1} %4, 0
  %6 = extractvalue {i16, i1} %4, 1
  %7 = trunc i16 %5 to i8
  %8 = insertvalue {i8, i1} undef, i8 %7, 0
  %9 = insertvalue {i8, i1} %8, i1 %6, 1
  ret {i8, i1} %9
}
declare {i16, i1} @llvm.smul.with.overflow.i16(i16, i16) #0

define {i8, i1} @__nvvm_u8_mulo(i8, i8) #0 {
start:
  %2 = sext i8 %0 to i16
  %3 = sext i8 %1 to i16
  %4 = call {i16, i1} @llvm.umul.with.overflow.i16(i16 %2, i16 %3)
  %5 = extractvalue {i16, i1} %4, 0
  %6 = extractvalue {i16, i1} %4, 1
  %7 = trunc i16 %5 to i8
  %8 = insertvalue {i8, i1} undef, i8 %7, 0
  %9 = insertvalue {i8, i1} %8, i1 %6, 1
  ret {i8, i1} %9
}
declare {i16, i1} @llvm.umul.with.overflow.i16(i16, i16) #0

attributes #0 = { alwaysinline speculatable }
attributes #1 = { alwaysinline }
