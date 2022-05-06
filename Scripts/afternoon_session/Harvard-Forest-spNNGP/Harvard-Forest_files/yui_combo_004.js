/*
 * UCLA course format utils
 */

YUI.add('moodle-format_ucla-utils', function(Y) {

    M.format_ucla = M.format_ucla || {};

    M.format_ucla.utils = {
        init: function(config) {

            var toggle = Y.one('.registrar-summary .registrar-summary-hidden');

            if (toggle) {
                // Set the toggle click.
                toggle.one('.collapse-toggle').on('click', this.toggle_reg_desc);
            }

        },
        toggle_reg_desc: function(e) {
            e.preventDefault();
            var target = e.target;

            if (target.hasClass('toggle-show')) {
                target.ancestor('.registrar-summary-hidden').one('.text_to_html').setStyle('display', 'none');
                target.set('text', M.util.get_string('collapsedshow', 'format_ucla'));
            } else {
                target.ancestor('.registrar-summary-hidden').one('.text_to_html').setStyle('display', 'block');
                target.set('text', M.util.get_string('collapsedhide', 'format_ucla'));
            }
            target.toggleClass('toggle-show');
        }
    }

}, '@VERSION@', {
    requires: ['node']
});