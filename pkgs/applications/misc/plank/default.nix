{ stdenv, fetchurl, vala, atk, cairo, glib, gnome3, gtk3, libwnck3
, libX11, libXfixes, libXi, pango, intltool, pkgconfig, libxml2
, bamf, gdk-pixbuf, libdbusmenu-gtk3, file, gnome-menus, libgee
, wrapGAppsHook, autoreconfHook, pantheon }:

stdenv.mkDerivation rec {
  pname = "plank";
  version = "0.11.4";

  src = fetchurl {
    url = "https://launchpad.net/${pname}/1.0/${version}/+download/${pname}-${version}.tar.xz";
    sha256 = "1f41i45xpqhjxql9nl4a1sz30s0j46aqdhbwbvgrawz6himcvdc8";
  };

  nativeBuildInputs = [
    autoreconfHook
    gnome3.gnome-common
    intltool
    libxml2 # xmllint
    pkgconfig
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    atk
    bamf
    cairo
    gdk-pixbuf
    glib
    gnome-menus
    gnome3.dconf
    gtk3
    libX11
    libXfixes
    libXi
    libdbusmenu-gtk3
    libgee
    libwnck3
    pango
  ];

  # fix paths
  makeFlags = [
    "INTROSPECTION_GIRDIR=${placeholder ''out''}/share/gir-1.0/"
    "INTROSPECTION_TYPELIBDIR=${placeholder ''out''}/lib/girepository-1.0"
  ];

  # Make plank's application launcher hidden in Pantheon
  patches = [ ./hide-in-pantheon.patch ];

  postPatch = ''
    substituteInPlace ./configure \
      --replace "/usr/bin/file" "${file}/bin/file"
  '';

  meta = with stdenv.lib; {
    description = "Elegant, simple, clean dock";
    homepage = https://launchpad.net/plank;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ davidak ] ++ pantheon.maintainers;
  };
}
