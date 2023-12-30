mod kernelsu;

#[derive(Debug)]
pub enum RootImpl {
    None,
    TooOld,
    Abnormal,
    Multiple,
    KernelSU,
}

static mut ROOT_IMPL: RootImpl = RootImpl::None;

pub fn setup() {
    let ksu_version = kernelsu::get_kernel_su();

    let impl_ = match ksu_version {
        None => RootImpl::None,
        Some(ksu_version) => {
            match ksu_version {
                kernelsu::Version::Supported => RootImpl::KernelSU,
                kernelsu::Version::TooOld => RootImpl::TooOld,
                kernelsu::Version::Abnormal => RootImpl::Abnormal,
            }
        }
    };
    unsafe { ROOT_IMPL = impl_; }
}

pub fn get_impl() -> &'static RootImpl {
    unsafe { &ROOT_IMPL }
}

pub fn uid_granted_root(uid: i32) -> bool {
    match get_impl() {
        RootImpl::KernelSU => kernelsu::uid_granted_root(uid),
        _ => panic!("uid_granted_root: unknown root impl {:?}", get_impl()),
    }
}

pub fn uid_should_umount(uid: i32) -> bool {
    match get_impl() {
        RootImpl::KernelSU => kernelsu::uid_should_umount(uid),
        _ => panic!("uid_should_umount: unknown root impl {:?}", get_impl()),
    }
}
