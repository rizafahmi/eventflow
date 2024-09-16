with import <nixpkgs> {};
let

	basePackages = [
	    gnumake
	    gcc
	    readline
	    openssl
	    zlib
	    libxml2
	    curl
	    libiconv
	    glibcLocales
	    nodejs_22
	    yarn
	    postgresql
	  ];

	inputs = basePackages
	    ++ lib.optional stdenv.isLinux inotify-tools
	    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
		CoreFoundation
		CoreServices
	      ]);

	hooks = ''
	    # this allows mix to work on the local directory
	    mkdir -p .nix-mix
	    mkdir -p .nix-hex
	    export MIX_HOME=$PWD/.nix-mix
	    export HEX_HOME=$PWD/.nix-hex
	    export PATH=$MIX_HOME/bin:$PATH
	    export PATH=$HEX_HOME/bin:$PATH
	    export LANG=en_US.UTF-8
	    export ERL_AFLAGS="-kernel shell_history enabled"
	  '';

in
pkgs.mkShellNoCC {
  buildInputs = inputs;
  shelHook = hooks;
}


