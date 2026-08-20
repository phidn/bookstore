import { SidebarProvider, SidebarInset, SidebarTrigger } from "@/components/ui/sidebar";
import { AppSidebar, type SectionKey } from "@/components/admin/AppSidebar";

interface AdminShellProps {
  active?: SectionKey;
  storeName: string;
  showLogout?: boolean;
  showShipping?: boolean;
  children: React.ReactNode;
}

export function AdminShell({
  active,
  storeName,
  showLogout,
  showShipping,
  children,
}: AdminShellProps) {
  return (
    <SidebarProvider>
      <AppSidebar
        active={active}
        storeName={storeName}
        showLogout={showLogout}
        showShipping={showShipping}
      />
      <SidebarInset className="min-w-0 flex-1 bg-background">
        <header className="flex h-14 shrink-0 items-center gap-2 border-b border-sidebar-border px-4 bg-sidebar sticky top-0 z-10">
          <SidebarTrigger className="-ml-1 text-muted-foreground hover:text-foreground cursor-pointer" />
          <div className="h-4 w-px bg-sidebar-border shrink-0 mx-1 self-center" aria-hidden="true" />
          <div className="flex items-center gap-2 text-xs uppercase tracking-wider text-muted-foreground font-medium">
            <span>Admin</span>
            <span className="text-muted-foreground/60">/</span>
            <span className="text-foreground font-semibold">{active ?? "Dashboard"}</span>
          </div>
        </header>
        <div className="flex-1 p-6 md:p-8 max-w-6xl w-full mx-auto">
          {children}
        </div>
      </SidebarInset>
    </SidebarProvider>
  );
}
