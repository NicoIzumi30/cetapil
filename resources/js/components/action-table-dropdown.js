document.addEventListener('DOMContentLoaded', function() {
    // Handle dropdown toggles
    document.addEventListener('click', function(event) {
        // Close all dropdowns when clicking outside
        if (!event.target.closest('.dropdown-button')) {
            document.querySelectorAll('.dropdown-menu').forEach(menu => {
                menu.classList.add('hidden');
            });
        }
        
        // Toggle dropdown if clicking a dropdown button
        if (event.target.closest('.dropdown-button')) {
            const button = event.target.closest('.dropdown-button');
            const menu = button.nextElementSibling;
            
            // Close all other dropdowns
            document.querySelectorAll('.dropdown-menu').forEach(otherMenu => {
                if (otherMenu !== menu) {
                    otherMenu.classList.add('hidden');
                }
            });
            
            // Toggle the clicked dropdown
            menu.classList.toggle('hidden');
            event.stopPropagation();
        }
    });
});