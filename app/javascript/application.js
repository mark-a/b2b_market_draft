// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "jquery"
import "popper"
import "bootstrap"
import "controllers"

let ready_function = function () {

    $('.new_filter').off('change').on('change',function () {
        let scope = this;
        let value_type = $(this).children("option:selected").data("type");
        let divisor = $(this).children("option:selected").data("divisor");
        let value = $(this).val();
        if (value == '') {
            $(this).parents("form").find(".new_filter_range_value").prop("disabled", true);
            $(this).parents("form").find(".new_filter_set_value").prop("disabled", true);
        } else {
            if (value_type === "range") {
                let step =  (1. / Number.parseFloat(divisor)).toFixed(3);
                $(this).parents("form").find(".new_filter_range_value").prop("disabled", false);
                $(this).parents("form").find(".new_filter_range_value").prop("step", step.toString());
                $(this).parents("form").find(".new_filter_set_value").val("");
                $(this).parents("form").find(".new_filter_set_value").prop("disabled", true);
            } else {
                $.get({
                    url: "/search/criterium/" + value,
                    type: "GET",
                    success: function (response) {
                        var tasks = response["values"];
                        $(scope).parents("form").find(".new_filter_set_value").empty();
                        $(scope).parents("form").find(".new_filter_set_value").append('<option> </option>');
                        for(var i = 0; i < tasks.length; i++){
                            $(scope).parents("form")
                                .find(".new_filter_set_value")
                                .append('<option value="' + tasks[i][1] + '">' +tasks[i][0] + '</option>');
                        }
                    }
                });
                $(this).parents("form").find(".new_filter_set_value").prop("disabled", false);
                $(this).parents("form").find(".new_filter_range_value").val("");
                $(this).parents("form").find(".new_filter_range_value").prop("disabled", true);
            }
        }
    });
};

$(document).ready(ready_function);

$(document).on("turbo:load", () => {
    $('[data-bs-toggle="tooltip"]').tooltip()
    $('[data-bs-toggle="popover"]').popover()
    $('[data-bs-toggle="toast"]').toast('show')
	ready_function();
})
