const baseURL = "http://localhost:8080"
async function createUser(name: string): Promise<void> {
    const res = await fetch(`${baseURL}/user/${name}`, {
        method: "POST",
    })
    if (!res.ok) {
        throw new Error(`ユーザー: ${name}の作成に失敗しました`)
    }
}
async function send(from: string, to: string, point: number): Promise<void> {
    const res = await fetch(`${baseURL}/send/${from}/${to}`, {
        method: "POST",
        body: JSON.stringify({ point }),
        headers: { "Content-Type": "application/json" }
    })
    if (!res.ok) {
        throw new Error(`送金に失敗しました`)
    }
}
async function get(name: string): Promise<number> {
    const res = await fetch(`${baseURL}/user/${name}`)
    if (!res.ok) {
        throw new Error(`ユーザー: ${name}の取得に失敗しました`)
    }
    const point = await res.text()
    return Number(point)
}

// await createUser("user1")
// console.log(await get("user1"))
// await createUser("user2")
// await createUser("user3")
// await createUser("user4")
// await createUser("user5")
//
// // // 1: -100, 2: 100, 3: 0, 4: 0, 5: 0
// await send("user1", "user2", 100)
// 1: -100, 2: 0, 3: 100, 4: 0, 5: 0
await send("user2", "user3", 100)
// 1: -100, 2: 0, 3: -100, 4: 200, 5: 0
await send("user3", "user4", 200)
// 1: -100, 2: 0, 3: -100, 4: 100, 5: 100
await send("user4", "user5", 100)
console.log(await get("user1"), await get("user2"), await get("user3"), await get("user4"), await get("user5"))
