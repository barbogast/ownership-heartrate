type Value = string | number | null | undefined
type Row = Record<string, Value>
type ReturnValue = Row[]

type Data = {
  dateTime: string, value: {
    bpm: number,
    confidence: number
  }
}[]

function postProcess(data: Data): ReturnValue | Promise<ReturnValue> {
  return data.map(row => ({
    dateTime: row.dateTime,
    bpm: row.value.bpm,
    confidence: row.value.confidence,
  }))
}
