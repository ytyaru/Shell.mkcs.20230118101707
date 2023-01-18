#!/usr/bin/env bash
#set -Ceu
#---------------------------------------------------------------------------
# C#のクラスライブラリとNUnitのプロジェクトをもったソリューション一式を作成する
# CreatedAt: 2023-01-18
#---------------------------------------------------------------------------
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; PARENT="$(dirname "$HERE")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$PARENT";
	cd "$HERE"
	[ -f 'error.sh' ] && . error.sh
	local PJ=;
	local CLS=;
	local IS_RUN_TEST=;
	local DEBUG=;
	ParseCommand() {
		THIS_NAME=`basename "$BASH_SOURCE"`
		SUMMARY='C#のクラスライブラリとNUnitのプロジェクトをもったソリューション一式を作成する。'
		VERSION=0.0.1
		ARG_FLAG=; ARG_OPT=;
		Help() { eval "echo -e \"$(cat help.txt)\""; }
		Version() { echo "$VERSION"; }
		while getopts ":hvtd" OPT; do
		case $OPT in
			h) Help; exit 0;;
			v) Version; exit 0;;
			t) IS_RUN_TEST=1; ;;
			d) DEBUG=1; ;;
		esac
		done
		shift $(($OPTIND - 1))
		ParseSubCommand() {
			[ $# -lt 1 ] && return || :;
			case $1 in
			-h|--help) Help; exit 0;;
			-v|--version) Version; exit 0;;
			-t|--test) IS_RUN_TEST=1; ;;
			-d|--debug) DEBUG=1; ;;
			esac
		}
		ParseSubCommand "$@"
	}
	SetArgs() {
		for ARG; do
			[[ $ARG =~ \-.+ ]] && { Debug "オプション引数なので飛ばす:$ARG"; continue; } || :;
			[ -z "$PJ" ] && { Debug "PJにセットする:$ARG"; PJ="$ARG"; continue; } || :;
			[ -z "$CLS" ] && { Debug "CLSにセットする:$ARG"; CLS="$ARG"; continue; } || :;
		done
		local D_PJ="$(date +CsPj%Y%m%d%H%M%S)"
		local D_CLS='Human'
		[ -z "$PJ" ] && PJ="$D_PJ" || :;
		[ -z "$CLS" ] && CLS="$D_CLS" || :;
		Debug "PJ:$PJ"
		Debug "CLS:$CLS"
		Debug "IS_RUN_TEST:$IS_RUN_TEST"
		Debug "DEBUG:$DEBUG"
		[ -d "./$PJ" ] && Error "作成を中断しました。指定したプロジェクト名のディレクトリは既存です。別名に変えるか同名ディレクトリがない場所で再実行してください。: $PJ" || :;
	}
	MakeProjects() {
		dotnet new sln -o "$PJ"
		cd "$PJ"
		dotnet new classlib -o Source -n "$PJ"
		dotnet new nunit -o Test
		dotnet sln add "./Test/Test.csproj"
		cd Test
		dotnet add reference "../Source/${PJ}.csproj"
		cd ..
	}
	MakeSourceCodeTpl() {
		rm ./Source/Class1.cs
		rm ./Test/UnitTest1.cs
		export PJ="$PJ"
		export CLS="$CLS"
		WriteTplFile() { cat "$1" | mo >| "$2"; }
		WriteTplFile "$HERE/tpl/Human.cs" "./Source/${CLS}.cs"
		WriteTplFile "$HERE/tpl/Test.cs" "./Test/${CLS}.cs"
	}
	RunTest() { [[ $IS_RUN_TEST -eq 1 ]] && dotnet test || :; }
	ParseCommand "$@"
	SetArgs "$@"
	MakeProjects
	MakeSourceCodeTpl
	Success "C#プロジェクトの作成が完了しました：$PJ"
	RunTest
}
Run "$@"
