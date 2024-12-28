// import { cookies } from "next/headers";
import { LoginForm } from '@/components/LoginForm'

// const cookieOptions = {
//   path: "/",
//   httpOnly: true,
//   sameSite: "lax",
// };


export default async function LoginPage() {
  // const cookieStore = await cookies()

  // const setIdCookie = await (_session_id: string) => {
  //   const cookieStore = cookies();
  //   cookieStore.set({ name: "user_uuid", value: _session_id, ...cookieOptions });
  // };
  return (
    <div className="flex items-center justify-center min-h-screen bg-gray-100">
      <LoginForm />
    </div>
  )
}

