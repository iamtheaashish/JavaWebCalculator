<!DOCTYPE html>
<html lang="en">
<head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Modern Web Calculator</title>
      <style>
            :root {
                  color-scheme: light;
                  --bg: #0f172a;
                  --card: #111827;
                  --text: #e2e8f0;
                  --muted: #94a3b8;
                  --primary: #38bdf8;
                  --danger: #f87171;
                  --success: #4ade80;
                  --border: #1f2937;
            }
            * {
                  box-sizing: border-box;
                  margin: 0;
                  padding: 0;
                  font-family: "Segoe UI", system-ui, -apple-system, sans-serif;
            }
            body {
                  min-height: 100vh;
                  background: radial-gradient(circle at top, #1e293b, #020617);
                  display: flex;
                  align-items: center;
                  justify-content: center;
                  padding: 2rem;
                  color: var(--text);
            }
            .card {
                  width: min(760px, 100%);
                  background: rgba(17, 24, 39, 0.92);
                  border: 1px solid var(--border);
                  border-radius: 24px;
                  padding: 2.5rem;
                  box-shadow: 0 20px 60px rgba(15, 23, 42, 0.4);
                  backdrop-filter: blur(6px);
            }
            header {
                  margin-bottom: 2rem;
            }
            header h1 {
                  font-size: 2.2rem;
                  margin-bottom: 0.5rem;
            }
            header p {
                  color: var(--muted);
            }
            .grid {
                  display: grid;
                  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                  gap: 1.5rem;
            }
            label {
                  display: block;
                  font-size: 0.95rem;
                  margin-bottom: 0.45rem;
                  color: var(--muted);
            }
            input[type="number"] {
                  width: 100%;
                  padding: 0.75rem 1rem;
                  border-radius: 12px;
                  border: 1px solid var(--border);
                  background: #0b1220;
                  color: var(--text);
                  font-size: 1rem;
            }
            .ops {
                  display: flex;
                  flex-wrap: wrap;
                  gap: 0.75rem;
                  margin-top: 0.5rem;
            }
            .ops label {
                  display: inline-flex;
                  align-items: center;
                  gap: 0.5rem;
                  background: #0b1220;
                  border: 1px solid var(--border);
                  border-radius: 999px;
                  padding: 0.45rem 0.9rem;
                  cursor: pointer;
                  color: var(--text);
            }
            .actions {
                  display: flex;
                  justify-content: flex-end;
                  margin-top: 2rem;
            }
            button {
                  background: linear-gradient(135deg, #38bdf8, #6366f1);
                  border: none;
                  color: #0f172a;
                  font-weight: 600;
                  padding: 0.85rem 2rem;
                  border-radius: 999px;
                  cursor: pointer;
                  font-size: 1rem;
                  transition: transform 0.2s ease, box-shadow 0.2s ease;
            }
            button:hover {
                  transform: translateY(-1px);
                  box-shadow: 0 8px 20px rgba(56, 189, 248, 0.3);
            }
            .result {
                  margin-top: 2rem;
                  padding: 1.25rem 1.5rem;
                  border-radius: 16px;
                  background: #0b1220;
                  border: 1px solid var(--border);
            }
            .result h3 {
                  margin-bottom: 0.4rem;
            }
            .result.success {
                  border-color: rgba(74, 222, 128, 0.4);
            }
            .result.error {
                  border-color: rgba(248, 113, 113, 0.5);
                  color: var(--danger);
            }
      </style>
</head>
<body>
<%
      String input1 = (String) request.getAttribute("input1");
      String input2 = (String) request.getAttribute("input2");
      String op = (String) request.getAttribute("op");
      String result = (String) request.getAttribute("result");
      String operationLabel = (String) request.getAttribute("operationLabel");
      String error = (String) request.getAttribute("error");

      if (input1 == null) { input1 = ""; }
      if (input2 == null) { input2 = ""; }
%>
      <div class="card">
            <header>
                  <h1>Modern Web Calculator</h1>
                  <p>Fast, accurate, and easy to use. Supports decimals and division.</p>
            </header>
            <form action="firstHomePage" method="post">
                  <div class="grid">
                        <div>
                              <label for="n1">First number</label>
                              <input id="n1" type="number" name="n1" step="any" placeholder="e.g. 12.5" value="<%= input1 %>" required />
                        </div>
                        <div>
                              <label for="n2">Second number</label>
                              <input id="n2" type="number" name="n2" step="any" placeholder="e.g. 3.2" value="<%= input2 %>" required />
                        </div>
                  </div>
                  <div style="margin-top: 1.5rem;">
                        <label>Choose an operation</label>
                        <div class="ops">
                              <label>
                                    <input type="radio" name="op" value="add" <%= "add".equals(op) ? "checked" : "" %> />
                                    Add
                              </label>
                              <label>
                                    <input type="radio" name="op" value="sub" <%= "sub".equals(op) ? "checked" : "" %> />
                                    Subtract
                              </label>
                              <label>
                                    <input type="radio" name="op" value="mul" <%= "mul".equals(op) ? "checked" : "" %> />
                                    Multiply
                              </label>
                              <label>
                                    <input type="radio" name="op" value="div" <%= "div".equals(op) ? "checked" : "" %> />
                                    Divide
                              </label>
                        </div>
                  </div>
                  <div class="actions">
                        <button type="submit">Calculate</button>
                  </div>
            </form>

            <% if (error != null && !error.isEmpty()) { %>
                  <div class="result error">
                        <h3>There was a problem</h3>
                        <p><%= error %></p>
                  </div>
            <% } else if (result != null) { %>
                  <div class="result success">
                        <h3><%= operationLabel %> Result</h3>
                        <p><strong><%= result %></strong></p>
                  </div>
            <% } %>
      </div>
</body>
</html>
