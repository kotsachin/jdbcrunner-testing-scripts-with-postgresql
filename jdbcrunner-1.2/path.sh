
count=1

#for file in ./scripts/logs/*.csv
#do
#date=$(echo "$file" | cut -c 20-27)
#img=$(echo "$file" | cut -c 20-36)
#echo $img
#echo $date
#mkdir -p ./benchmark/$date
#mkdir -p ./benchmark/$date/round$count
#done



#for file in ./scripts/logs/*.csv
#do
#date=$(echo "$file" | cut -c 20-27)

#mkdir -p ./benchmark/$date
#mkdir -p ./benchmark/$date/Round$count


#img=$(echo "$file" | cut -c 20-36)
#mkdir -p ./benchmark/$date/Round$count/mylogs

#sed 's/,/\t/g' $file > ./benchmark/$date/Round$count/mylogs/$img.dat
#echo $file
#done


for file in ./benchmark/20130207/Round$count/mylogs/*_t.dat
do
#gnuplot << EOF
#set   autoscale
#set xlabel "Elapsed Time \(seconds)"
#set ylabel "Throughput (Number of transaction)"
#set grid
#set terminal png
#set output "test.png"
#plot "$file"  using 1:2 title 'Transaction Type-1' with linespoints
#EOF

img=$(echo "$file" | cut -c 36-52)
#mkdir -p ./benchmark/$date/Round$count/Gnuplot
#mv test.png ./benchmark/$date/Round$count/Gnuplot/$img.png
echo $img
done

