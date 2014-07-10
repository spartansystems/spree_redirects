Deface::Override.new(:virtual_path  => "spree/admin/shared/_configuration_menu",
                     :name          => "spree_redirect_config_opt",
                     :insert_bottom => "[data-hook='admin_configurations_sidebar_menu']",
                     :partial       => "spree/admin/shared/redirect_config",
                     :disabled      => false)
