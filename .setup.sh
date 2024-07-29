#!/bin/sh

_args_def() {
    val=$1
    def=$2
    if [ $val -eq 0 ]; then
        return $def
    else
        return $val
    fi
}

_ARGS_MAX_ARGS_DEF=16
_ARGS_BUF_SIZE_DEF=$((_ARGS_MAX_ARGS_DEF * 1024))

_ARGS_EXPECT_KEY=$((1 << 0))
_ARGS_EXPECT_SEP=$((1 << 1))
_ARGS_EXPECT_VAL=$((1 << 2))
_ARGS_PARSING_KEY=$((1 << 3))
_ARGS_PARSING_VAL=$((1 << 4))
_ARGS_ERROR=$((1 << 5))

_args_max_args=0;
_args_num_args=0;
_args_args_keys="";
_args_args_vals="";
_args_buf_size=0;
_args_buf_pos=0;
_args_buf="";
_args_valid=false;
_args_parse_state=0;
_args_quote=0;
_args_in_escape=false;

_args_putc() {
    c=$1
    if [ $((_args_buf_pos + 2)) -lt $_args_buf_size ]; then
        _args_buf="$_args_buf$c"
        _args_buf_pos=$((_args_buf_pos + 1))
    fi
}

_args_str() {
    index=$1
    echo "${_args_buf:index}"
}

_args_expect_key() {
    _args_parse_state=$_ARGS_EXPECT_KEY;
}

_args_key_expected() {
    [ $((_args_parse_state & $_ARGS_EXPECT_KEY)) -ne 0 ]
}

_args_expect_val() {
    _args_parse_state=$_ARGS_EXPECT_VAL
}

_args_val_expected() {
    [ $((_args_parse_state & $_ARGS_EXPECT_VAL)) -ne 0 ]
}

_args_expect_sep_or_key() {
    _args_parse_state=$((_ARGS_EXPECT_SEP | _ARGS_EXPECT_KEY))
}

_args_any_expected() {
    [ $((_args_parse_state & (_ARGS_EXPECT_KEY | _ARGS_EXPECT_VAL | _ARGS_EXPECT_SEP))) -ne 0 ]
}

_args_is_separator() {
    c=$1
    [ $c -eq "=" ]
}

_args_is_quote() {
    c=$1
    if [ "$_args_quote" -eq 0 ]; then
        [ "$c" = "'" ] || [ "$c" = '"' ]
    else
        [ "$c" = "$_args_quote" ]
    fi
}

_args_begin_quote() {
    c=$1
    _args_quote="$c"
}

_args_end_quote() {
    _args_quote=0
}

_args_in_quotes() {
    [ _args_quote -ne 0 ]
}

_args_is_whitespace() {
    c=$1
    [ _args_in_quotes() -eq 0 ] && { [ "$c" = ' ' ] || ["$c" = $'\t' ]; }
}

_args_start_key() {
    _args_parse_state=$_ARGS_PARSING_KEY
    _args_args_keys="$_args_args_keys,$_args_buf_pos"
}

_args_end_key() {
    _args_putc 0
    _args_args_vals="$_args_args_vals,$((_args_buf_pos - 1))"
    _args_num_args=$((_args_num_args + 1))
    _args_parse_state=0
}

_args_parsing_key() {
    [ $((_args_parse_state & _ARGS_PARSING_KEY)) -ne 0 ]
}

_args_start_val() {
    _args_parse_state=$_ARGS_PARSING_VAL
    _args_args_vals="$_args_args_vals,$_args_buf_pos"
}

_args_end_val() {
    _args_putc 0
    _args_parse_state=0
}

_args_is_escape() {
    c=$1
    [ "$c" = '\\' ]
}

_args_start_escape() {
    _args_in_escape=true
}

_args_escape() {
    c=$1
    case "$c" in
        n)
            echo -e '\n'
            ;;
        t)
            echo -e '\t'
            ;;
        r)
            echo -e '\r'
            ;;
        \\)
            echo -e '\\'
            ;;
        *)
            echo -n "$c"
            ;;
    esac
}

_args_end_escape() {
    _args_in_escape=false
}

_args_parsing_val() {
    [ $((_args_parse_state & _ARGS_PARSING_VAL)) -ne 0 ]
}

_args_parse_carg() {
    local src="$1"
    local c
    local inx=0
    while [ $inx -lt ${#src} ]; do
        c="${src:$inx:1}"
        inx=$((inx + 1))

        if _args_in_escape; then
            c=$(_args_escape "$c")
            _args_end_escape
        elif _args_is_escape "$c"; then
            _args_start_escape
            continue
        fi

        if _args_any_expected;
            if ! _args_is_whitespace "$c"; then
                if _args_is_separator "$c"; then
                    _args_expect_val
                    continue
                elif _args_key_expected; then
                    _args_start_key
                elif _args_val_expected; then
                    if _args_is_quote "$c"; then
                        _args_begin_quote "$c"
                        continue
                    fi
                    _args_start_val
                fi
            else
                continue
            fi
        elif _args_parsing_key; then
            if _args_is_whitespace "$c" || _args_is_separator "$c"; then
                _args_end_key
                if _args_is_separator "$c"; then
                    _args_expect_val
                else
                    _args_expect_sep_or_key
                fi
                continue
            fi
        elif _args_parsing_val; then
            if _args_in_quotes; then
                if _args_is_quote "$c"; then
                    _args_end_quote
                    _args_end_val
                    _args_expect_key
                    continue
                fi
            elif _args_is_whitespace "$c"; then
                _args_end_val
                _args_expect_key
                continue
            fi
        fi
        _args_putc "$c"
    done

    if _args_parsing_key; then
        _args_end_key
        _args_expect_sep_or_key
    elif _args_parsing_val && ! _args_in_quotes; then
        _args_end_val
        _args_expect_key
    fi
}

_args_parse_cargs() {
    local argc=$1
    local argv=$2
    for i in "${@:2}"; do
        _args_parse_carg "$i"
    done
    _args_parse_state=0
}

args_setup() {
    
}

args_shutdown() {

}

args_isvalid {

}

args_exists {

}

args_value {

}

args_value_def {

}

args_equals {

}

args_boolean {

}

args_find {

}

args_num_args {

}

args_key_at {

}

args_value_at {

}
