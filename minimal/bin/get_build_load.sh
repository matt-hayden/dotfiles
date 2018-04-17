#! /bin/bash
bc << EOF
$(nproc) - 0.5
EOF
