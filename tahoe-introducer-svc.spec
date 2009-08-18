Name:      tahoe-introducer-svc
Version:   0.1.0
Release:   2
Summary:   tahoe-introducer-svc daemontools configuration
Group:     System/Server
URL:       http://allmydata.org/trac/tahoe
Vendor:    Allmydata.org
Packager:  Rogério Carvalho Schneider <stockrt@gmail.com>
License:   GPL
BuildArch: noarch
Source:    %{name}-%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id} -un)
Requires:  daemontools

# Recommended Topdir
%define _topdir %(echo $HOME)/rpmbuild
# So the build does not fail due to unpackaged files or missing doc files:
%define _unpackaged_files_terminate_build 0
%define _missing_doc_files_terminate_build 0
# No debug package:
%define debug_package %{nil}

%description
tahoe-introducer-svc daemontools configuration

%prep
%setup -q -n %{name}

%build

%install
%{__rm} -rf %{buildroot}

%{__install} -m 0755 -d %{buildroot}%{_prefix}/local/%{name}
%{__install} -m 0755 -d %{buildroot}%{_prefix}/local/%{name}/bin
%{__install} -m 0755 -d %{buildroot}%{_prefix}/local/%{name}/conf

%{__install} -m 0755 -d %{buildroot}%{_var}/log/%{name}

%{__install} -m 0755 bin/* %{buildroot}%{_prefix}/local/%{name}/bin/
%{__install} -m 0644 conf/* %{buildroot}%{_prefix}/local/%{name}/conf/

%files
%defattr(-,root,root,-)
%dir %{_prefix}/local/%{name}
%dir %{_prefix}/local/%{name}/bin
%dir %{_prefix}/local/%{name}/conf
%dir %{_var}/log/%{name}
%{_prefix}/local/%{name}/bin/*
%config(noreplace) %{_prefix}/local/%{name}/conf/*

%clean
%{__rm} -rf %{buildroot}

%post
# daemontools register
%svc_post
svcdir=tahoe-introducer
%svc_mkrun
#!/bin/bash
exec 2>&1
exec %{_prefix}/local/%{name}/bin/%{name}
%svc_mklogrun
#!/bin/bash
exec multilog t n10 s1048576 %{_var}/log/%{name}
%svc_regsrv -d

%preun
# daemontools unregister
%svc_preun
svclist='tahoe-introducer'
%svc_unregsrv

%changelog
* Tue Aug 18 2009 - Rogério Carvalho Schneider <stockrt@gmail.com> - 0.1.0-2
- Added exec fd redir (exec 2>&1)

* Mon Jun  8 2009 - Rogério Carvalho Schneider <stockrt@gmail.com> - 0.1.0-1
- Initial packing
