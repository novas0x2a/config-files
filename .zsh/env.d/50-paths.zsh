local PROJECT_DIR=~/Projects

if [[ -d $PROJECT_DIR/VisionWorkbench/scripts/python ]]; then
    python_path=($PROJECT_DIR/VisionWorkbench/scripts/python $python_path)
fi

perl_path=($HOME/local/lib/perl5/site_perl $HOME/local/lib/perl5 $perl_path)

fpath=($HOME/.zsh/functions $fpath)
cdpath+=$PROJECT_DIR
path=(~/Projects/piston/Miracle-Max/bin ~/bin ~/.local/bin ~/local/noarch/bin ~/local/bin ~/.gems/bin /opt/local/bin $path)

ldpath=($HOME/local/lib $ldpath)
pkg_path=($HOME/local/lib/pkgconfig $pkg_path)
