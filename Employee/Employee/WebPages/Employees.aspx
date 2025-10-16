<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Employees.aspx.cs" Inherits="Employee.WebPages.Employees" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
Employee Registration</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
<style>
        .emp-form {
            max-width: 600px;
            margin: 40px auto;
            padding: 25px;
            border: 1px solid #ccc;
            border-radius: 8px;
            background: #f9f9f9;
        }
        .emp-form h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .emp-form label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
        }
        .emp-form input, .emp-form select, .emp-form textarea {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border-radius: 4px;
            border: 1px solid #bbb;
            box-sizing: border-box;
        }
        .emp-form button {
            display: block;
            width: 100%;
            margin-top: 20px;
            padding: 10px;
            font-size: 16px;
            color: #fff;
            background-color: #0078D7;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .emp-form button:hover {
            background-color: #005fa3;
        }

        .error {
    color: #c00;
    font-size: 13px;
    display: block;
    margin-top: 4px;
}

.invalid-field {
    border: 2px solid #c00 !important;
    box-shadow: 0 0 3px rgba(200,0,0,0.2);
}
    </style>
    
     <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/Scripts/validation.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>



<script>
$(function () {
    // Validate single field on blur (immediate feedback)
    $("[data-type]").on("blur input change", function () {
        ValidationEngine.validateField(this);
    });

    // On register click: validate all and then send AJAX
    $("#btnRegister").on("click", function () {
        // validate all elements inside our container
        const ok = ValidationEngine.validateAll("#employeeForm"); // validates all [data-type] inside

        if (!ok) {
            // Scroll to first invalid field for better UX
            const $first = $(".invalid-field").first();
            if ($first.length) {
                $('html,body').animate({ scrollTop: $first.offset().top - 20 }, 200);
                $first.focus();
            }
            return;
        }

        // build object from fields
        var empData = {
            Name: $("#empName").val().trim(),
            Email: $("#empEmail").val().trim(),
            Phone: $("#empPhone").val().trim(),
            Gender: $("#empGender").val().trim(),
            Department: $("#empDept").val().trim(),
            Address: $("#empAddress").val().trim()
        };

        // AJAX post to WebMethod
        $.ajax({
            type: "POST",
            url: "Employees.aspx/SaveEmployee",
            data: JSON.stringify({ emp: empData }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (res) {
                alert(res.d || "Saved.");
                // clear fields and errors
                $("#employeeForm").find("input, textarea, select").val("");
                $(".error").text("");
                $(".invalid-field").removeClass("invalid-field");
            },
            error: function (xhr) {
                // show server error
                alert("Server error: " + (xhr.responseText || xhr.statusText));
                console.error(xhr);
            }
        });
    });
});
</script>


    
   

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="emp-form" id="employeeForm">  <!-- a container, not a form tag -->
        <h2>Employee Registration</h2>

        <label for="empName">Full Name</label>
        <input type="text" id="empName" data-type="name" placeholder="Enter full name" />
        <span id="empName-error" class="error"></span>

        <label for="empEmail">Email Address</label>
        <input type="text" id="empEmail" data-type="email" placeholder="example@domain.com" />
        <span id="empEmail-error" class="error"></span>

        <label for="empPhone">Phone Number</label>
        <input type="text" id="empPhone" data-type="phone" placeholder="1234567890" />
        <span id="empPhone-error" class="error"></span>

        <label for="empGender">Gender</label>
        <select id="empGender" data-type="text">
            <option value="">-- Select Gender --</option>
            <option>Male</option>
            <option>Female</option>
            <option>Other</option>
        </select>
        <span id="empGender-error" class="error"></span>

        <label for="empDept">Department</label>
        <input type="text" id="empDept" data-type="text" placeholder="e.g. HR, IT" />
        <span id="empDept-error" class="error"></span>

        <label for="empAddress">Address</label>
        <textarea id="empAddress" data-type="min:10" placeholder="Enter address"></textarea>
        <span id="empAddress-error" class="error"></span>

        <button type="button" id="btnRegister">Register Employee</button>
    </div>
</asp:Content>

