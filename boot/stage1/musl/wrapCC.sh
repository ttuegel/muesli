mkdir -pv "${out:?}/bin"

for prog in "${cc:?}"/bin/*
do
    dest="${out:?}/bin/$(basename $prog)"
    case "$prog" in
        *c++ | *gcc | *g++)
            cat > "${dest:?}" <<EOF
#!/bin/sh
exec "$prog" -specs "${specs:?}" "\$@"
EOF
            chmod +x "${dest:?}"
            ;;
        *)
            ln -s "$prog" "${dest:?}"
            ;;
    esac
done
