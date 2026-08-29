# packages/a/AzureHound.nix
#
# https://github.com/SpecterOps/AzureHound/releases/
#

{
	lib,
	buildGoModule,
	fetchFromGitHub,
	versionCheckHook,
}:

buildGoModule (finalAttrs: {
	pname = "azurehound";
	version = "3.1.0";

	src = fetchFromGitHub {
		owner = "SpecterOps";
		repo = "AzureHound";
		tag = "v${finalAttrs.version}";
		hash = "sha256-WtT56qFwpAVTyWKH8Bun9irr0DHbzLDcvV3VPXEw8BE=";
	};

	patches =
		let
			patchDirectory = ./patches + "/${finalAttrs.version}";
		in
		lib.optionals (builtins.pathExists patchDirectory) (
			lib.filter (
				path: lib.hasSuffix ".patch" (toString path)
			) (lib.filesystem.listFilesRecursive patchDirectory)
		);

	vendorHash = "sha256-WF46wXaNU/Em0KpF6hkuuJ+7K1IKLGqpNS/HxpxX5WY=";

	ldflags = [
		"-s"
		"-w"
		"-X=github.com/bloodhoundad/azurehound/v2/constants.Version=${finalAttrs.version}"
	];

	# TestBatch races a 5 ms sleep against a 5 ms batch timeout.
	checkFlags = [ "-skip=^TestBatch$" ];

	nativeInstallCheckInputs = [ versionCheckHook ];
	doInstallCheck = true;

	meta = {
		description = "Azure Data Exporter for BloodHound, patched with OPSEC-friendly defaults.";
		homepage = "https://github.com/SpecterOps/AzureHound";
		changelog = "https://github.com/SpecterOps/AzureHound/releases/tag/${finalAttrs.src.tag}";
		license = lib.licenses.gpl3Only;
		mainProgram = "azurehound";
		platforms = lib.platforms.linux;
	};
})

