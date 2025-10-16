// /Scripts/validation.js
// Small reusable validation engine that uses data-type attributes.
// - validateField($el) validates a single jQuery element
// - validateAll(selector) validates all elements matched by selector
// - registerRule(type, fn) allows adding custom rules

(function (global, $) {
    if (!$) throw new Error("jQuery is required for validation.js");

    console.log("✅ validation.js loaded");

    // rule functions map: return { ok: boolean, message: string }
    const rules = {};

    // ------------------------------------------------------------------
    // Register a new rule programmatically
    // ------------------------------------------------------------------
    function registerRule(type, fn) {
        rules[type] = fn;
    }

    // ------------------------------------------------------------------
    // Built-in validation rules
    // ------------------------------------------------------------------

    registerRule("required", (value) => {
        return value === "" 
            ? { ok: false, message: "This field is required." } 
            : { ok: true };
    });

    registerRule("name", (value) => {
        value = value.trim();
        if (value.length < 3) return { ok: false, message: "At least 3 characters required." };
        if (!/^[A-Za-z ]+$/.test(value)) return { ok: false, message: "Only letters and spaces allowed." };
        return { ok: true };
    });

    registerRule("email", (value) => {
        const p = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;
        return p.test(value)
            ? { ok: true }
            : { ok: false, message: "Enter a valid email address." };
    });

    registerRule("phone", (value) => {
        const p = /^[0-9]{10}$/; // allows only 10 digits
        return p.test(value)
            ? { ok: true }
            : { ok: false, message: "Enter a valid 10-digit phone number." };
    });

    registerRule("number", (value) => {
        return /^\d+$/.test(value)
            ? { ok: true }
            : { ok: false, message: "Only numeric values allowed." };
    });

    registerRule("text", (value) => {
        return value === ""
            ? { ok: false, message: "This field cannot be empty." }
            : { ok: true };
    });

    // ------------------------------------------------------------------
    // Validate a single field (jQuery element)
    // ------------------------------------------------------------------
    function validateField($el) {
        const id = $el.attr("id");
        if (!id) return true; // Can't show error without id, treat as valid

        const $error = $("#" + id + "-error");
        $error.text("");

        const raw = ($el.val() || "").toString().trim();
        $el.val(raw); // normalize trimmed value back into input

        const types = ($el.data("type") || "")
            .toString()
            .split("|")
            .map(s => s.trim())
            .filter(Boolean);

        // handle data-required="true" shortcut
        if (($el.data("required") === true || $el.data("required") === "true") && raw === "") {
            $error.text("This field is required.");
            $el.addClass("invalid-field");
            return false;
        }

        // Run rules in sequence; stop on first failure
        for (let t of types) {
        // Support paramized types like min:3 or pattern:^\d+$
            if (t.indexOf(":") > -1) {
                const [base, param] = t.split(/:(.+)/); // split only first colon
                if (base === "min") {
                    const min = parseInt(param, 10);
                    if (raw.length < min) {
                        $error.text(`Minimum ${min} characters required.`);
                        $el.addClass("invalid-field");
                        return false;
                    } else continue;
                }
                if (base === "pattern") {
                    let regex;
                    try { regex = new RegExp(param); } catch (err) { continue; }
                    if (!regex.test(raw)) {
                        $error.text("Invalid format.");
                        $el.addClass("invalid-field");
                        return false;
                    } else continue;
                }
            }

        // Normal rule
            const ruleFn = rules[t];
            if (!ruleFn) {
                console.warn(`⚠️ Unknown validation rule: ${t}`);
                continue;
            }

            const result = ruleFn(raw);
            if (!result.ok) {
                $error.text(result.message || "Invalid value.");
                $el.addClass("invalid-field");
                return false;
            }
        }

        // Passed all checks
        $el.removeClass("invalid-field");
        $error.text("");
        return true;
    }

    // ------------------------------------------------------------------
    // Validate all elements inside a selector or container
    // ------------------------------------------------------------------
    function validateAll(selectorOrContainer) {
        let $els;
        if (typeof selectorOrContainer === "string") {
            // if container selector, find data-type inside
            $els = $(`${selectorOrContainer} [data-type]`);
            if ($els.length === 0) $els = $(selectorOrContainer).filter("[data-type]");
        } else {
            $els = $("[data-type]");
        }

        let ok = true;
        $els.each(function () {
            const $f = $(this);
            const fieldOk = validateField($f);
            if (!fieldOk) ok = false;
        });
        return ok;
    }

    // ------------------------------------------------------------------
    // Expose public API
    // ------------------------------------------------------------------
    global.ValidationEngine = {
        registerRule,
        validateField: function (elOrSelector) {
            const $el = (elOrSelector instanceof $) ? elOrSelector : $(elOrSelector);
            if ($el.length === 0) return true;
            return validateField($el.eq(0));
        },
        validateAll
    };

})(window, window.jQuery);
