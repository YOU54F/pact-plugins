
#[cfg(any(target_os = "macos", target_os = "linux"))]
pub mod signal_handler {
    use std::{io::Error, mem, os::raw::c_int, ptr};
    use libc::{sigaction, SA_ONSTACK};
    use tracing::debug;



    fn fix_signal(signum: c_int) -> Result<(), Error> {
        let mut st: sigaction = unsafe { mem::zeroed() };
        if unsafe { sigaction(signum, ptr::null(), &mut st) } < 0 {
            return Err(Error::last_os_error());
        }
        st.sa_flags |= SA_ONSTACK;
        if unsafe { sigaction(signum, &st, ptr::null_mut()) } < 0 {
            return Err(Error::last_os_error());
        }
        debug!("Signal handler installed for signal: {}", signum);
        Ok(())
    }

    pub fn install_signal_handlers() {
        {
            debug!("Fixing signal for signal - SIGCHLD: {}", libc::SIGCHLD);
            fix_signal(libc::SIGCHLD).unwrap();
            debug!("Fixing signal for signal - SIGHUP: {}", libc::SIGHUP);
            fix_signal(libc::SIGHUP).unwrap();
            debug!("Fixing signal for signal - SIGINT: {}", libc::SIGINT);
            fix_signal(libc::SIGINT).unwrap();
            debug!("Fixing signal for signal - SIGQUIT: {}", libc::SIGQUIT);
            fix_signal(libc::SIGQUIT).unwrap();
            debug!("Fixing signal for signal - SIGABRT: {}", libc::SIGABRT);
            fix_signal(libc::SIGABRT).unwrap();
            debug!("Fixing signal for signal - SIGFPE: {}", libc::SIGFPE);
            fix_signal(libc::SIGFPE).unwrap();
            debug!("Fixing signal for signal - SIGTERM: {}", libc::SIGTERM);
            fix_signal(libc::SIGTERM).unwrap();
            debug!("Fixing signal for signal - SIGBUS: {}", libc::SIGBUS);
            fix_signal(libc::SIGBUS).unwrap();
            debug!("Fixing signal for signal - SIGSEGV: {}", libc::SIGSEGV);
            fix_signal(libc::SIGSEGV).unwrap();
            debug!("Fixing signal for signal - SIGXCPU: {}", libc::SIGXCPU);
            fix_signal(libc::SIGXCPU).unwrap();
            debug!("Fixing signal for signal - SIGXFSZ: {}", libc::SIGXFSZ);
            fix_signal(libc::SIGXFSZ).unwrap();

        }
    }
}
