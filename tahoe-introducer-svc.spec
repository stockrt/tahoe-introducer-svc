Name:      tahoe-introducer-svc
Version:   0.1.0
Release:   1
Summary:   tahoe-introducer-svc daemontools configuration
Group:     System/Server
URL:       http://stockrtweb.homelinux.com
Vendor:    Allmydata.org
Packager:  Rogerio Carvalho Schneider <stockrt@gmail.com>
License:   GPL
BuildArch: noarch
Source:    %{name}-%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
Requires:  daemontools

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

%{__install} -m 0755 -d %{buildroot}/var/log/%{name}

%{__install} -m 0755 bin/* %{buildroot}%{_prefix}/local/%{name}/bin/
%{__install} -m 0644 conf/* %{buildroot}%{_prefix}/local/%{name}/conf/

%files
%defattr(-,root,root,-)
%dir %{_prefix}/local/%{name}
%dir %{_prefix}/local/%{name}/bin
%dir %{_prefix}/local/%{name}/conf
%dir /var/log/%{name}
%{_prefix}/local/%{name}/bin/*
%config(noreplace) %{_prefix}/local/%{name}/conf/*

%clean
%{__rm} -rf %{buildroot}

%post
%svc_post
# daemontools register
svcdir=tahoe-introducer
%svc_mkrun
#!/bin/bash
exec %{_prefix}/local/%{name}/bin/%{name}
%svc_mklogrun
#!/bin/bash
exec multilog t n10 s1048576 /var/log/%{name}
%svc_regsrv -dr

%preun
%svc_preun
svclist="tahoe-introducer"
%svc_unregsrv

%changelog
* Mon Jun  8 2009 - Rogerio Carvalho Schneider <stockrt@gmail.com> - 0.1.0-1
- Initial packing
