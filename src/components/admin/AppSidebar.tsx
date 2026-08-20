import * as React from "react";
import {
  LayoutDashboard,
  Package,
  ShoppingCart,
  Users,
  FolderTree,
  FileText,
  Compass,
  Truck,
  Image as ImageIcon,
  Settings,
  Store,
  LogOut,
} from "lucide-react";
import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarGroup,
  SidebarGroupContent,
  SidebarGroupLabel,
  SidebarHeader,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
  SidebarRail,
  SidebarSeparator,
} from "@/components/ui/sidebar";

export type SectionKey =
  | "dashboard"
  | "products"
  | "orders"
  | "customers"
  | "categories"
  | "media"
  | "pages"
  | "navigation"
  | "shipping"
  | "settings";

interface AppSidebarProps extends React.ComponentProps<typeof Sidebar> {
  active?: SectionKey;
  storeName: string;
  showLogout?: boolean;
  showShipping?: boolean;
}

export function AppSidebar({
  active,
  storeName,
  showLogout = false,
  showShipping = true,
  ...props
}: AppSidebarProps) {
  const storeItems = [
    { key: "dashboard", label: "Dashboard", href: "/admin", icon: LayoutDashboard },
    { key: "products", label: "Products", href: "/admin/products", icon: Package },
    { key: "orders", label: "Orders", href: "/admin/orders", icon: ShoppingCart },
    { key: "customers", label: "Customers", href: "/admin/customers", icon: Users },
    { key: "categories", label: "Categories", href: "/admin/categories", icon: FolderTree },
    ...(showShipping
      ? [{ key: "shipping", label: "Shipping", href: "/admin/shipping", icon: Truck }]
      : []),
  ];

  const contentItems = [
    { key: "pages", label: "Pages", href: "/admin/pages", icon: FileText },
    { key: "navigation", label: "Navigation", href: "/admin/navigation", icon: Compass },
    { key: "media", label: "Media", href: "/admin/media", icon: ImageIcon },
    { key: "settings", label: "Settings", href: "/admin/settings", icon: Settings },
  ];

  return (
    <Sidebar collapsible="icon" className="border-r border-border bg-sidebar" {...props}>
      <SidebarHeader className="border-b border-border/50 p-3">
        <SidebarMenu>
          <SidebarMenuItem>
            <SidebarMenuButton
              size="lg"
              render={<a href="/admin" />}
              tooltip={storeName}
              className="hover:bg-sidebar-accent group-data-[collapsible=icon]:justify-center group-data-[collapsible=icon]:p-0"
            >
              <img
                src="/logo.png"
                alt={storeName}
                className="size-8 rounded-lg object-contain bg-paper border border-border/70 p-0.5 shrink-0"
              />
              <div className="flex flex-col gap-0.5 leading-none group-data-[collapsible=icon]:hidden min-w-0 flex-1">
                <span className="font-semibold text-sm truncate text-foreground">{storeName}</span>
                <span className="text-[11px] text-muted-foreground">Admin Portal</span>
              </div>
            </SidebarMenuButton>
          </SidebarMenuItem>
        </SidebarMenu>
      </SidebarHeader>

      <SidebarContent className="px-2 py-3">
        <SidebarGroup>
          <SidebarGroupLabel className="text-[11px] font-medium tracking-wider uppercase text-muted-foreground px-2 group-data-[collapsible=icon]:hidden">
            Store
          </SidebarGroupLabel>
          <SidebarGroupContent>
            <SidebarMenu className="gap-1">
              {storeItems.map((item) => {
                const Icon = item.icon;
                const isActive = active === item.key;
                return (
                  <SidebarMenuItem key={item.key}>
                    <SidebarMenuButton
                      render={<a href={item.href} />}
                      isActive={isActive}
                      tooltip={item.label}
                      className="transition-colors hover:bg-sidebar-accent text-sm group-data-[collapsible=icon]:justify-center group-data-[collapsible=icon]:p-2"
                    >
                      <Icon className="size-4 shrink-0" />
                      <span className="group-data-[collapsible=icon]:hidden truncate">{item.label}</span>
                    </SidebarMenuButton>
                  </SidebarMenuItem>
                );
              })}
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>

        <SidebarSeparator className="my-2 opacity-50 group-data-[collapsible=icon]:hidden" />

        <SidebarGroup>
          <SidebarGroupLabel className="text-[11px] font-medium tracking-wider uppercase text-muted-foreground px-2 group-data-[collapsible=icon]:hidden">
            Content & Site
          </SidebarGroupLabel>
          <SidebarGroupContent>
            <SidebarMenu className="gap-1">
              {contentItems.map((item) => {
                const Icon = item.icon;
                const isActive = active === item.key;
                return (
                  <SidebarMenuItem key={item.key}>
                    <SidebarMenuButton
                      render={<a href={item.href} />}
                      isActive={isActive}
                      tooltip={item.label}
                      className="transition-colors hover:bg-sidebar-accent text-sm group-data-[collapsible=icon]:justify-center group-data-[collapsible=icon]:p-2"
                    >
                      <Icon className="size-4 shrink-0" />
                      <span className="group-data-[collapsible=icon]:hidden truncate">{item.label}</span>
                    </SidebarMenuButton>
                  </SidebarMenuItem>
                );
              })}
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>
      </SidebarContent>

      <SidebarFooter className="border-t border-border/50 p-2">
        <SidebarMenu className="gap-1">
          <SidebarMenuItem>
            <SidebarMenuButton
              render={<a href="/" />}
              tooltip="View Store"
              className="text-muted-foreground hover:text-foreground group-data-[collapsible=icon]:justify-center group-data-[collapsible=icon]:p-2"
            >
              <Store className="size-4 shrink-0" />
              <span className="group-data-[collapsible=icon]:hidden truncate">View store</span>
            </SidebarMenuButton>
          </SidebarMenuItem>
          {showLogout && (
            <SidebarMenuItem>
              <SidebarMenuButton
                render={<a href="/admin/logout" />}
                tooltip="Log Out"
                className="text-muted-foreground hover:text-destructive group-data-[collapsible=icon]:justify-center group-data-[collapsible=icon]:p-2"
              >
                <LogOut className="size-4 shrink-0" />
                <span className="group-data-[collapsible=icon]:hidden truncate">Log out</span>
              </SidebarMenuButton>
            </SidebarMenuItem>
          )}
        </SidebarMenu>
      </SidebarFooter>
      <SidebarRail />
    </Sidebar>
  );
}
