for i in 2.4 2.5 2.6; do
    if [[ -d $HOME/local/lib/python${i}/site-packages ]]; then
        python_path=($HOME/local/lib/python${i}/site-packages $python_path)
    fi
done

python_path=($HOME/local/python $python_path)

if [[ -d $HOME/Work/projects/VisionWorkbench/scripts/python ]]; then
    python_path=($HOME/Work/projects/VisionWorkbench/scripts/python $python_path)
fi

perl_path=($HOME/local/lib/perl5/site_perl $HOME/local/lib/perl5 $perl_path)

fpath=($HOME/.zsh/functions $fpath)
cdpath+=~/Work/projects
path=(~/bin ~/local/noarch/bin ~/local/bin ~/.gems/bin /opt/local/bin $path)

ldpath=($HOME/local/lib $ldpath)
pkg_path=($HOME/local/lib/pkgconfig $pkg_path)
