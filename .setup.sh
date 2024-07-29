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
_args_quote="";
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
