# osx-dev-stack

The goal of this project is to create an auto-installation procedure that starts with a clean (or close to clean) installation of OS X Lion (10.7.4 or later), or OS X Mountain Lion, and set up a software development environment for Linux and OS X software development, skewed towards scientific software development. Software included reflects my personal biases, and what I'm working on at the time.

# Dependencies

The general idea to start out with is to assume there's next to nothing on the machine. Dependencies are:

1. OS X Lion (10.7.4 or later) or OS X Mountain Lion, so by default, users should have:
2. bash
3. curl
4. Ruby 1.8.7
5. RubyGems (specific version doesn't matter)

So, in other words, users have next to nothing for development (not even a C compiler, possibly not X11).

# High-level Design Philosophy

I work on a number of different computers. I have two Mac laptops at home, and another at work. On trips, I may receive a loaner MacBook Pro or MacBook Air. In order to do any sort of software development work or academic writing, I need to be able to get the software stack I use on to those machines, especially after an OS upgrade. I put off OS upgrades precisely to avoid having to untangle my software development stack, and that's just a bad practice. I decided it was time to bite the bullet and write this tool to help me (and maybe other people).

The general design of this project is inspired by [ControlTier's white paper on fully automated system provisioning](http://blog.controltier.com/2009/04/new-whitepaper-achieving-fully.html). To summarize, they suggest three layers of automation:

1. OS Install/Cloud or VM Image Launch (this project uses a bash script).
2. System Configuration (this project uses Puppet)
3. Application Service Deployment (this project uses Fabric) 

In addition, each of these layers should be unit tested. Bash scripts will be unit tested with shunit2; Puppet scripts will be unit tested using rake and rspec-puppet; and Fabric scripts will be unit tested with Nose.

## "OS Install"

The VM Image Launch section doesn't apply, and I don't need the OS Install part; I usually end up doing that myself, or at work, I'm given a machine with the OS installed. In fact, at work, I'm not even allowed to install the OS, so I wanted that part to be separate. OS installation is turnkey anyway.

I will, however, need to install compilers and the X11 libraries on OS X in order to do any sort of system configuration. Consequently, I'll be using a `bash` script to bootstrap the system configuration process by downloading and installing compilers, libraries, and the system configuration tools. Furthermore, any open-source Mac apps will be installed using bash, because there's no good way to automate the install and uninstall processes.

## System Configuration

I'm interpreting "system configuration" in this setting to be "anything that isn't a Python, Ruby, or Perl package". I use each of these dynamic languages for development, in order of decreasing frequency. Crucially, each of these languages has a package manager. Anything that has its own package manager needs minimal configuration at this level. I've used Puppet in the past (in conjunction with Vagrant) for building virtual machines because Puppet has a large community associated with it and a number of famous enterprise users (including VMWare now). Due to that familiarity, and my satisfaction with it so far, I decided to use Puppet for this layer of the installation process.

Puppet works best when it can interface with a package manager. There are a number of package managers out there for Macs: MacPorts, Homebrew, Fink, Rudix, and others. While I've favored MacPorts in the past, I don't like their development philosophy (centralized), or their choice of language (Tcl). I have used MacPorts in the past and I've been pleased with the results. I originally used them because I've heard their packages required fewer fixes after OS upgrades. If I were just a consumer of the packaging system, I wouldn't care so much about development language or philosophy, but in my case, I'm going to have to write my own packages in order to automate the build process, and if I have to learn Tcl to do that, then get blessed by their development team, it's not worth it because it requires too much of a time investment for the return. Homebrew uses Ruby as its development language, which I already use for Puppet anyway, and I'm in the process of learning Jekyll, plus the Homebrew project has a decentralized development structure. There are also Homebrew providers for Puppet, so Homebrew will work well as a package manager for this project. If I didn't need to roll my own packages, MacPorts would work just fine. The main criticism of Homebrew is that it relies heavily on system libraries, and as a result, its packages may break on an OS upgrade, but this project is designed to recover from that scenario anyway; I'd also argue that reliance on system libraries is otherwise a strength because it means less duplication and less storage. I use MacPorts now, and I've already noticed that I inadvertently installed over my system Perl with the MacPorts Perl. I'd like to avoid that as much as possible.

## "Application service deployment" = Sandboxing Python, Ruby, and Perl installations

I'm interpreting "application service deployment" as "installation of sandboxed dynamic language environments". Puppet is really good at system-wide, global installations. However, in dynamic language software development, it's exceedingly helpful to have, on a per project basis, sandboxed installations containing only the necessary packages for the project, plus the interpreter version needed. Python developers do this using pythonbrew, virtualenv, and virtualenvwrapper. Ruby developers do this using rvm (or rbenv), RubyGems, and sometimes bundler. Perl developers could do this using perlbrew and local::lib. Puppet is not so good about creating sandboxed installations for these dynamic languages. Although Puppet can use pip and gem as package providers, as far as I know, there is no good implementation of virtualenv support for pip, and official [implementation of virtualenv support is still an outstanding issue in Puppet](https://projects.puppetlabs.com/issues/7286). Consequently, it's better to use a tool more suited to the task. In this case, I'm choosing Fabric, because I like Python as a language, I have more experience with Python, and the Fabric community seems to be more diverse than the communities of similar tools, like Capistrano (very Rails-centric), Func (Fedora-centric), and ControlTier (Java-centric). Python is also a popular language in the scientific community. I'd use a Python-based system configuration tool, but there is no good Python-based OS X package manager that has a large user community; ditto for system configuration software (Ruby dominates in this sphere, with Puppet and Chef). Since dynamic languages are often available across multiple platforms, it is also useful to separate this step from system configuration for modularity; deployment of these languages involves the same commands across all Unix-based OSes.





