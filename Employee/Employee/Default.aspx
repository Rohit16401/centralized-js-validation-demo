<%@ Page Title="Home — Centralized JS Validation Project" 
    Language="C#" 
    MasterPageFile="~/Site.Master" 
    AutoEventWireup="true" 
    CodeBehind="Default.aspx.cs" 
    Inherits="Employee.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Home — Centralized Validation Overview
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .hero {
            text-align: center;
            background: linear-gradient(120deg, #0078d7, #00b4d8);
            color: white;
            padding: 60px 20px;
            border-radius: 10px;
            margin-bottom: 40px;
        }
        .hero h1 {
            font-size: 2.2rem;
            margin-bottom: 10px;
        }
        .hero p {
            font-size: 1.1rem;
            opacity: 0.9;
        }
        .section {
            background: #fff;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.06);
            margin-bottom: 30px;
        }
        h2 {
            color: #0078d7;
            margin-bottom: 12px;
        }
        .cta-buttons {
            text-align: center;
            margin-top: 20px;
        }
        .btn {
            display: inline-block;
            background: #0078d7;
            color: #fff;
            padding: 10px 20px;
            border-radius: 6px;
            text-decoration: none;
            margin: 5px;
            transition: 0.3s;
        }
        .btn:hover {
            background: #005fa3;
        }
        ul {
            margin-left: 18px;
        }
        .credit {
            font-size: 13px;
            color: #555;
            background: #f9fafc;
            padding: 10px;
            border-left: 4px solid #0078d7;
            border-radius: 6px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="hero">
        <h1>🚀 Centralized JavaScript Validation</h1>
        <p>A single reusable validation engine for all your web forms — framework-independent and easy to extend.</p>
    </div>

    <div class="section">
        <h2>🔍 What Problem Does This Solve?</h2>
        <p>
            In most web projects, validation logic is duplicated across multiple forms and technologies.  
            Every page needs its own JS checks or server-side validation — making maintenance harder and inconsistent.
        </p>
        <p>
            This project demonstrates a <strong>centralized, attribute-driven validation system</strong> where:
        </p>
        <ul>
            <li>All rules are declared directly on inputs (e.g., <code>data-type="email|required|min:3"</code>).</li>
            <li>A single JavaScript file (<b>validation.js</b>) reads those attributes and applies matching checks.</li>
            <li>No dependency on ASP.NET — works equally well in HTML, MVC, React, or Angular.</li>
        </ul>
    </div>

    <div class="section">
        <h2>🧩 How It’s Structured</h2>
        <ul>
            <li><b>Home (this page)</b> — Overview and purpose</li>
            <li><b>Demo Form</b> — Real working example of centralized validation</li>
            <li><b>Explanation</b> — Deep dive into how the JS engine works</li>
        </ul>
        <div class="cta-buttons">
            <a href="~/WebPages/Employees.aspx" runat="server" class="btn">💼 Try the Demo</a>
            <a href="~/WebPages/Explanation.aspx" runat="server" class="btn">📘 Read the Explanation</a>
        </div>
    </div>

    <div class="section">
        <h2>💡 Key Features</h2>
        <ul>
            <li>✅ Works across any framework or plain HTML site</li>
            <li>⚙️ Fully customizable — add your own validation rules easily</li>
            <li>🚫 Prevents bad submissions before they reach the server</li>
            <li>🎨 Clean, readable, and developer-friendly</li>
        </ul>
    </div>

    <div class="section credit">
        <strong>Credits & Purpose:</strong>  
        This project is created to demonstrate how a <b>centralized, reusable JavaScript validation engine</b> can work seamlessly in modern and legacy web apps alike.  
        <br />Concept by <a href="https://github.com/Rohit16401"><b>Rohit Ashok Yadav</b></a> <a href="https://www.linkedin.com/in/rohit-ashok-yadav-84854a245/"><b>Linked In</b></a> • Implementation and documentation with help from <b>ChatGPT (GPT-5)</b>.  
        <br />Open-sourced for learning and real-world inspiration.
    </div>
</asp:Content>
