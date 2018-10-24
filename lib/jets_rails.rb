# = Configuration
#
# Configure with Rails initializer. Example:
#
# config/initializer/jets.rb:
#
#   JetsRails.stage = ENV['JETS_STAGE'] || 'dev'
#
# = Signal Trapping
#
# Puma uses a lot of different signals
# https://github.com/puma/puma/blob/master/docs/signals.md
#
# TTIN increment the worker count by 1
# TTOU decrement the worker count by 1
# TERM send TERM to worker. Worker will attempt to finish then exit.
# USR2 restart workers. This also reloads puma configuration file, if there is one.
# USR1 restart workers in phases, a rolling restart. This will not reload configuration file.
# HUP reopen log files defined in stdout_redirect configuration parameter. If there is no stdout_redirect option provided it will behave like INT
# INT equivalent of sending Ctrl-C to cluster. Will attempt to finish then exit.
# CHLD
#
# All signals:
#
# $ kill -l
# 1) SIGHUP       2) SIGINT       3) SIGQUIT      4) SIGILL       5) SIGTRAP
# 6) SIGABRT      7) SIGBUS       8) SIGFPE       9) SIGKILL     10) SIGUSR1
# 11) SIGSEGV     12) SIGUSR2     13) SIGPIPE     14) SIGALRM     15) SIGTERM
# 16) SIGSTKFLT   17) SIGCHLD     18) SIGCONT     19) SIGSTOP     20) SIGTSTP
# 21) SIGTTIN     22) SIGTTOU     23) SIGURG      24) SIGXCPU     25) SIGXFSZ
# 26) SIGVTALRM   27) SIGPROF     28) SIGWINCH    29) SIGIO       30) SIGPWR
# 31) SIGSYS      34) SIGRTMIN    35) SIGRTMIN+1  36) SIGRTMIN+2  37) SIGRTMIN+3
# 38) SIGRTMIN+4  39) SIGRTMIN+5  40) SIGRTMIN+6  41) SIGRTMIN+7  42) SIGRTMIN+8
# 43) SIGRTMIN+9  44) SIGRTMIN+10 45) SIGRTMIN+11 46) SIGRTMIN+12 47) SIGRTMIN+13
# 48) SIGRTMIN+14 49) SIGRTMIN+15 50) SIGRTMAX-14 51) SIGRTMAX-13 52) SIGRTMAX-12
# 53) SIGRTMAX-11 54) SIGRTMAX-10 55) SIGRTMAX-9  56) SIGRTMAX-8  57) SIGRTMAX-7
# 58) SIGRTMAX-6  59) SIGRTMAX-5  60) SIGRTMAX-4  61) SIGRTMAX-3  62) SIGRTMAX-2
# 63) SIGRTMAX-1  64) SIGRTMAX
#
# Using a signal that is not used by the puma webserver.
#
Signal.trap("IO") do # kill -29
  JetsRails::IO.flush
end

module JetsRails
  cattr_accessor :stage
  self.stage = "dev" # default. should be set to in Rails initializer

  autoload :StageMiddleware, 'jets_rails/stage_middleware'
end

require "jets_rails/io"
require "jets_rails/railtie"
require "jets_rails/kernel"
