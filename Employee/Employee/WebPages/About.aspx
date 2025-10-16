<%@ Page Title="About Centralized JS Validation" 
    Language="C#" 
    MasterPageFile="~/Site.Master" 
    AutoEventWireup="true" 
    CodeBehind="About.aspx.cs" 
    Inherits="Employee.WebPages.About" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>How Centralized JS Validation Works</title>
    <style>
        body { font-family: "Segoe UI", Roboto, Arial, sans-serif; background:#f6f8fb; color:#222; margin:28px; }
        .card { max-width:900px; margin:24px auto; background:#fff; padding:28px; border-radius:10px; box-shadow:0 6px 20px rgba(0,0,0,0.06); }
        h1 { color:#0b66c3; text-align:center; margin-bottom:6px; }
        h2 { color:#0b66c3; margin-top:18px; }
        p { line-height:1.6; }
        pre.code { background:#0f1724; color:#e6eef8; padding:12px; border-radius:6px; overflow:auto; font-size:13px; }
        pre.diagram { background:#eef6ff; border-left:4px solid #0b66c3; padding:12px; white-space:pre; font-family:monospace; color:#0b2f52; }
        .note { background:#fff8e6; border-left:4px solid #f59e0b; padding:10px; border-radius:6px; margin-top:16px; }
        ul { margin-left:18px; }
        .small { font-size:13px; color:#555; }
        .kbd { background:#f1f5f9; border:1px solid #e2e8f0; padding:2px 6px; border-radius:4px; font-family:monospace; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div class="card">
        <h1>Centralized JavaScript Validation — Step-by-Step</h1>
        <p class="small">
            <strong>Purpose:</strong> a single, reusable JavaScript engine that validates any HTML input by reading a simple attribute (like <span class="kbd">data-type="email"</span>).  
            This page explains the flow and shows minimal code snippets so you (or any developer) can copy the pattern into any web project.
        </p>

        <h2>High-level idea (one sentence)</h2>
        <p>
            Each input tells the validator what it expects (via <span class="kbd">data-type</span> or similar attributes). A central JS file reads those attributes, runs the correct checks, and displays inline errors — independent of framework or parent form tags.
        </p>

        <h2>Quick visual flow</h2>
        <pre class="diagram">
  +-------------------------------+
  | 1) HTML inputs declare rules  |
  |    (data-type="email|required")|
  +---------------+---------------+
                  |
                  v
  +---------------+---------------+
  | 2) validation.js boots on page |
  |    (or is imported per page)   |
  +---------------+---------------+
                  |
                  v
  +---------------+---------------+
  | 3) Engine scans inputs (by     |
  |    attribute) & validates each |
  +---------------+---------------+
                  |
                  v
  +---------------+---------------+
  | 4) On fail → show inline error |
  |    and add visual indication   |
  +---------------+---------------+
                  |
                  v
  +---------------+---------------+
  | 5) If all OK → allow submit /  |
  |    continue with AJAX or flow  |
  +-------------------------------+
        </pre>

        <h2>Required files (minimal)</h2>
        <ul>
            <li><strong>/src/validation.js</strong> — the engine (one file)</li>
            <li><strong>Any page</strong> includes jQuery or uses vanilla selectors; include <span class="kbd">validation.js</span>.</li>
            <li><strong>Optional demo folder</strong> with an example page and CSS for error styles.</li>
        </ul>

        <h2>Essential API & snippets</h2>
        <p class="small">Below are the smallest, most important pieces you need to integrate.</p>

        <h3>1) Minimal engine API (exposed object)</h3>
        <pre class="code">
// validation.js (essential API - pseudocode)
window.ValidationEngine = {
  registerRule(name, fn),    // add custom rule
  validateField(selectorOrEl), // validate single field
  validateAll(containerSelector) // validate many fields
};
        </pre>

       <h3>2) How you declare rules on inputs</h3>
<p class="small">(Do not include full form here — just the attribute pattern we use)</p>
<pre class="code">
&lt;!-- each input has an id and a data-type --&gt;
&lt;input id="emailInput" data-type="email|required" /&gt;
&lt;span id="emailInput-error" class="error"&gt;&lt;/span&gt;

&lt;input id="ageInput" data-type="number|min:18" /&gt;
&lt;span id="ageInput-error" class="error"&gt;&lt;/span&gt;
</pre>


        <h3>3) How to call the engine from a page</h3>
        <pre class="code">
/* on page ready (jQuery example) */
$(function(){
  // validate a single field on blur:
  $("[data-type]").on("blur input change", function(){
    ValidationEngine.validateField(this);
  });

  // validate all before submit or before sending AJAX:
  $("#submitButton").on("click", function(){
    if (!ValidationEngine.validateAll("#containerOrForm")) {
      // show errors, focus first invalid field, stop
      return;
    }
    // everything OK — continue (AJAX or normal submit)
  });
});
        </pre>

        <h2>How it decides which validation to run</h2>
        <p>
            The engine reads the <span class="kbd">data-type</span> attribute and splits rules by a separator (for example <span class="kbd">|</span>). Supported types can be built-in (like <span class="kbd">email</span>, <span class="kbd">phone</span>, <span class="kbd">required</span>, <span class="kbd">min:3</span>, <span class="kbd">pattern:regex</span>) and you can register new ones using <span class="kbd">registerRule()</span>.
        </p>

        <h2>Small example: registering a custom rule (snippet)</h2>
        <pre class="code">
/* add this inside validation.js or on startup */
ValidationEngine.registerRule("zipcode", function(value){
  // returns { ok: boolean, message: "..." }
  return (/^\d{5}$/).test(value) ? { ok:true } : { ok:false, message: "Enter 5 digits" };
});
        </pre>

        <h2>What the engine does when validation fails</h2>
        <ul>
            <li>Writes an inline message into an element with ID convention: <code>&lt;field-id&gt;-error</code>.</li>
            <li>Adds a CSS class (e.g. <span class="kbd">invalid-field</span>) to highlight the field.</li>
            <li>Stops further action (blocks submit / cancels AJAX) until fields are corrected.</li>
        </ul>

        <h2>Server-side (critical) — never skip</h2>
        <p class="small">
            Client validation is for UX. Always replicate the same checks on the server before you save or process data. In this demo we use an ASP.NET WebForms page with a <span class="kbd">[WebMethod]</span> or regular postback — but the server rules are identical in principle.
        </p>

        <h2>Folder structure recommendation</h2>
        <pre class="code">
js-validation-engine/
├── README.md
├── LICENSE (MIT)
├── src/
│   └── validation.js     // clean library
├── demo/
│   ├── index.html        // simple demo page (uses the library)
│   └── style.css
        </pre>

        <h2>Best practices & tips</h2>
        <ul>
            <li><strong>Keep rules human-readable:</strong> <code>data-type="email|required"</code> is easy to understand and maintain.</li>
            <li><strong>Focus on UX:</strong> validate on <em>blur</em> and again before submit; show the first invalid field and focus it.</li>
            <li><strong>Be extensible:</strong> expose <code>registerRule()</code> so teams add domain rules easily.</li>
            <li><strong>Accessibility:</strong> ensure error spans are connected using <code>aria-describedby</code> if needed.</li>
            <li><strong>Testing:</strong> create small automated tests (or manual test matrix) for each rule (valid and invalid cases).</li>
        </ul>

        <h2>Why this is useful across frameworks</h2>
        <p>
            The validation code operates on plain DOM elements by attributes — it has zero dependency on server frameworks or view engines. That means you can reuse the same file:
        </p>
        <ul>
            <li>Directly in plain HTML pages</li>
            <li>Inside an ASP.NET WebForms app (this demo)</li>
            <li>Inside MVC / Razor / Blazor (front-end side)</li>
            <li>Inside SPA frameworks — the same rules can be called from React/Vue/Angular wrappers</li>
        </ul>

        <div class="note">
            <strong>Note on provenance:</strong> This demo uses an ASP.NET Web Forms project to show integration in an older framework.  
            The idea for a centralized engine was proposed by <b>Rohit</b>; the implementation and code examples were developed with help from ChatGPT (GPT-5).  
            This repository is educational and open for reuse (consider an MIT license).
        </div>

        
    </div>
    </form>
</body>
</html>
