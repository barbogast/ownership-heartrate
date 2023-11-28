type Value = string | number | null | undefined
type Row = Record<string, Value>

// TODO: Specify the actual type of the JSON data here
type Data = {
  dateTime: string, value: {
    bpm: number,
    confidence: number
  }
}[]

type Filename = string
type Files = Record<string, Data>

type ReturnValue = Row[]

function postProcess(files: Files): ReturnValue | Promise<ReturnValue> {
  // Flatten all files into a single array of rows
  return Object.values(files).flatMap(file => file.map(row => {
    const [dateStr, timeStr] = row.dateTime.split(' ')
    const [month, day, year] = dateStr.split('/')
    // const [hour, minute, second] = timeStr.split(':')
    const iso = `20${year}-${month}-${day}T${timeStr}`
    const unixTimestamp = Math.floor(Date.parse(iso) / 1000)

    return {
      timestamp: unixTimestamp,
      dateTime: row.dateTime,
      bpm: row.value.bpm,
      confidence: row.value.confidence,
    }
  }))
}