#!/bin/bash
set -e

# Fix for SAM Python runtime validation
echo "🔧 Checking for Python 3.11 compatibility..."
PY_PATH=$(which python3 || true)

for bin in /usr/bin/python /bin/python /usr/bin/python3 /bin/python3; do
  if [ ! -f "$bin" ]; then
    echo "⚙️ Linking $PY_PATH to $bin"
    ln -s $PY_PATH $bin || true
  fi
done

echo "🚀 Deploying the SAM stack..."
sam deploy --guided
