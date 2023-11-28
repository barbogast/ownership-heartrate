type Value = string | number | null | undefined
type Row = Record<string, Value>
type ReturnValue = Row[]

type Data = {
  dateTime: string, value: {
    bpm: number,
    confidence: number
  }
}[]
type Files = Record<string, Data>

function postProcess(files: Files): ReturnValue | Promise<ReturnValue> {
  return Object.values(files)[0]!.map(row => ({
    dateTime: row.dateTime,
    bpm: row.value.bpm,
    confidence: row.value.confidence,
  }))
}
