<%@ Page Title="Explanation — How Centralized JS Validation Works"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Explanation.aspx.cs"
    Inherits="Employee.WebPages.Explanation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Explanation — Centralized JS Validation
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        body { font-family: "Segoe UI", Roboto, Arial, sans-serif; background:#f6f8fb; color:#222; margin:28px; }
        .card { max-width:900px; margin:24px auto; background:#fff; padding:28px; border-radius:10px; box-shadow:0 6px 20px rgba(0,0,0,0.06); }
        h1 { color:#0b66c3; text-align:center; margin-bottom:6px; }
        h2 { color:#0b66c3; margin-top:18px; }
        h3 { color:#0b66c3; margin-top:14px; }
        p { line-height:1.6; }
        pre.code { background:#0f1724; color:#e6eef8; padding:12px; border-radius:6px; overflow:auto; font-size:13px; }
        pre.diagram { background:#eef6ff; border-left:4px solid #0b66c3; padding:12px; white-space:pre; font-family:monospace; color:#0b2f52; }
        .note { background:#fff8e6; border-left:4px solid #f59e0b; padding:10px; border-radius:6px; margin-top:16px; }
        ul { margin-left:18px; }
        .small { font-size:13px; color:#555; }
        .kbd { background:#f1f5f9; border:1px solid #e2e8f0; padding:2px 6px; border-radius:4px; font-family:monospace; }
        .highlight { background:#e7f5ff; border-left:4px solid #0b66c3; padding:10px; border-radius:6px; margin:16px 0; }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card">
        <h1>Centralized JavaScript Validation — Explained Simply</h1>

        <p>
            Web developers often end up writing **form validation logic repeatedly** — one script per form.  
            This approach is hard to maintain and error-prone.  
            The concept below demonstrates how to use **one reusable JavaScript file** that automatically validates all form fields, 
            based on small hints added to HTML inputs.
        </p>

        <div class="highlight">
            💡 <strong>In this demo:</strong> The example is built inside an <b>ASP.NET WebForms</b> app to show that this idea works even in legacy frameworks.
            The same principle applies to <b>any web framework</b> — React, Angular, MVC, Razor, or plain HTML.
        </div>

        <h2>1️⃣ The Core Concept</h2>
        <p>
            Each input field carries a <span class="kbd">data-type</span> attribute describing which rules to apply.  
            The central JavaScript file reads these attributes dynamically, performs validation, and shows errors — no custom per-page JS required.
        </p>

        <pre class="code">
&lt;input id="emailInput" data-type="email|required" /&gt;
&lt;span id="emailInput-error" class="error"&gt;&lt;/span&gt;

&lt;input id="ageInput" data-type="number|min:18" /&gt;
&lt;span id="ageInput-error" class="error"&gt;&lt;/span&gt;
        </pre>

        <h2>2️⃣ How It Flows Behind the Scenes</h2>
        <pre class="diagram">
  +--------------------------------------+
  | 1) Input declares validation rules   |
  |    via data-type="email|required"    |
  +------------------+-------------------+
                     |
                     v
  +------------------+-------------------+
  | 2) validation.js scans all inputs    |
  |    and interprets the data-type      |
  +------------------+-------------------+
                     |
                     v
  +------------------+-------------------+
  | 3) Each rule runs & returns result   |
  |    { ok: true/false, message: ... }  |
  +------------------+-------------------+
                     |
                     v
  +------------------+-------------------+
  | 4) JS updates UI: shows/hides errors |
  +--------------------------------------+
        </pre>

        <h2>3️⃣ The Central Engine (Simplified)</h2>
        <pre class="code">
// validation.js (simplified idea)
window.ValidationEngine = {
  rules: {},

  registerRule: function(name, fn) {
    this.rules[name] = fn;
  },

  validateField: function(el) {
    const rules = el.dataset.type.split('|');
    for (let r of rules) {
      let [rule, arg] = r.split(':');
      if (this.rules[rule] && !this.rules[rule](el.value, arg)) {
        document.getElementById(el.id + "-error").textContent = "Invalid " + rule;
        return false;
      }
    }
    document.getElementById(el.id + "-error").textContent = "";
    return true;
  },

  validateAll: function(formSelector) {
    let valid = true;
    document.querySelectorAll(formSelector + " [data-type]").forEach(el => {
      if (!this.validateField(el)) valid = false;
    });
    return valid;
  }
};
        </pre>

        <h3>Common Built-In Rules Example</h3>
        <ul>
            <li><b>required</b> — field must not be empty</li>
            <li><b>email</b> — must be a valid email address</li>
            <li><b>number</b> — only digits allowed</li>
            <li><b>min:18</b> — number must be ≥ 18</li>
        </ul>

        <h2>4️⃣ Using It in a Real ASP.NET Form</h2>
        <p>
            Here’s how it connects to a Web Form, for example your <b>Employee Form</b>:
        </p>
        <pre class="code">
&lt;asp:TextBox ID="txtName" runat="server" data-type="required" /&gt;
&lt;span id="txtName-error" class="error"&gt;&lt;/span&gt;

&lt;asp:TextBox ID="txtEmail" runat="server" data-type="email|required" /&gt;
&lt;span id="txtEmail-error" class="error"&gt;&lt;/span&gt;

&lt;asp:Button ID="btnSave" runat="server" Text="Save" OnClientClick="return ValidationEngine.validateAll('#form1');" /&gt;
        </pre>
        <p>
            ✅ The button will only submit if all rules return <b>true</b>.
        </p>

        <h2>5️⃣ Why It’s Framework-Agnostic</h2>
        <ul>
            <li>Works in **ASP.NET Web Forms** (classic or modernized)</li>
            <li>Same logic applies in **React, Angular, Vue**, etc.</li>
            <li>No backend dependency — purely **front-end logic**</li>
            <li>Easy to extend — add new rules once, used everywhere</li>
        </ul>

        <h2>6️⃣ Typical Integration Script</h2>
        <pre class="code">
$(function() {
  $("[data-type]").on("blur input change", function() {
    ValidationEngine.validateField(this);
  });

  $("#submitButton").on("click", function() {
    if (!ValidationEngine.validateAll("#myForm")) {
      alert("Please fix validation errors first.");
      return false;
    }
  });
});
        </pre>

        <div class="note">
            <strong>Educational Summary:</strong><br />
            This demonstration shows how <b>centralized validation</b> lets you manage all input checks from a single JS file.  
            The approach was showcased here in an <b>ASP.NET WebForms</b> app — proving that even old frameworks can benefit from modern, generic JS techniques.  
            <br /><br />
            The concept was proposed by <a href="https://github.com/Rohit16401"><b>Rohit Ashok Yadav</b></a> <a href="https://www.linkedin.com/in/rohit-ashok-yadav-84854a245/"><b>Linked In</b></a>and co-created with <b>ChatGPT (GPT-5)</b> to help developers modernize legacy systems while maintaining simplicity and reusability.
        </div>
    </div>
</asp:Content>
