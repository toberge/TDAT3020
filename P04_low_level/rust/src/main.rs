fn sanitize(s: &String) -> String {
    let mut o: String = String::with_capacity(s.len() * 2);
    for c in s.chars() {
        match c {
            '&' => o += "&amp;",
            '<' => o += "&lt;",
            '>' => o += "&gt;",
            _ => o.push(c),
        }
    }
    o
}

fn main() {
    let s: String = String::from("<h1>griffin & kryuger</h1>");
    let san = sanitize(&s);
    println!("{} -> {}", s, san);
}
