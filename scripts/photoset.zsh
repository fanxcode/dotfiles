for d in *" Set."*; do
  main="${d% Set.*}"     # 去掉最后的 " Set.xx"
  mkdir -p "$main"
  mv "$d"/* "$main/"
  rm -rf "$d"
done

