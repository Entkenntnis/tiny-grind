for f in casc-30-auto/*.lean; do
    echo "=== $f ===" >> output.txt
    lake lean "$f" >> output.txt
    echo >> output.txt
done