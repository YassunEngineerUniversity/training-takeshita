'use client'

import { createContext, useContext, useState, useEffect } from 'react';

interface User {
  id: number;
  name: string;
}

interface AuthContextType {
  user: User | null;
  setUser: (user: User | null) => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);

  useEffect(() => {
    (async () => {
      try {
        const response = await fetch('/api/login', {
          credentials: 'include'  // Cookieを含める
        });
        if (response.ok) {
          const userData = await response.json();
          setUser(userData);
        }
      } catch (error) {
        console.error('Failed to fetch user:', error);
      }
    })()
  }, []);

  // const fetchUser = async () => {
  //   try {
  //     const response = await fetch('/api/session', {
  //       credentials: 'include'  // Cookieを含める
  //     });
  //     if (response.ok) {
  //       const userData = await response.json();
  //       setUser(userData);
  //     }
  //   } catch (error) {
  //     console.error('Failed to fetch user:', error);
  //   }
  // };

  return (
    <AuthContext.Provider value={{ user, setUser }}>
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};