
type Value = string | number | null | Row[]
type Row = {timestamp: number, bpm: number}
type Table = Row[]

function transform(tables: Table[]): Table {
  // Your code here ...
  const groupByTime = {}
  for (const row of tables[0]) {
    const datetime = new Date(row.timestamp * 1000)
    const time = `${datetime.getHours()}:${datetime.getMinutes()}`
    const date = `${datetime.getFullYear()}-${datetime.getMonth()}-${datetime.getDate()}`
    console.log(time, date)
    const timeBucket = groupByTime[time] || {time}
    timeBucket[date]= row.bpm
    groupByTime[time] = timeBucket
  }
  console.log(groupByTime ,   Object.values(groupByTime)) 
  

  return Object.values(groupByTime)
}
