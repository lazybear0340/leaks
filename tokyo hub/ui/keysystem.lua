--was obfuscated by moonveil 2.0.23


local LocalPlayer, TweenService, UserInputService, HttpService, FromRGB, R11_Result, Keysystem_Key_Txt, Hui_Result, TokyoKeySystem, TokyoKeySystem_2, PlayerGui, TokyoKeySystem_3, TokyoKeySystem_4, UDim2_New, DropShadowHolder, UIScale, Vector2_New, ImageLabel, Frame, UDim_New, UICorner, UIStroke, UIScale_2, TweenInfo_New, Frame_2, InputBegan, UserInputType, InputChanged, ImageLabel_2, Font_New, KEY_SYSTEM, Frame_3, UICorner_2, X, Activated, UIScale_3, MouseButton1Down, MouseButton1Up, MouseLeave, Welcome_To_The, Tokyo_Hub, Paste, UICorner_3, UIScale_4, MouseButton1Down_2, MouseButton1Up_2, MouseLeave_2, TextBox, UICorner_4, UIStroke_2, UIPadding, Activated_2, Submit_Key, UICorner_5, UIStroke_3, UIScale_5, MouseButton1Down_3, MouseButton1Up_3, MouseLeave_3, TextButton, UIScale_6, MouseButton1Down_4, MouseButton1Up_4, MouseLeave_4, Frame_4, Frame_5, UIListLayout, LootLabs, UICorner_6, UIStroke_4, ImageLabel_3, UIScale_7, MouseButton1Down_5, MouseButton1Up_5, MouseLeave_5, Linkvertise, UICorner_7, UIStroke_5, ImageLabel_4, UIScale_8, MouseButton1Down_6, MouseButton1Up_6, MouseLeave_6, Work_Ink, UICorner_8, UIStroke_6, ImageLabel_5, UIScale_9, MouseButton1Down_7, MouseButton1Up_7, MouseLeave_7, TextLabel, Frame_6, UICorner_9, TextLabel_2, Frame_7, UIListLayout_2, Activated_3, Frame_8, UICorner_10, Copied_Key_LootLabs_Link, Activated_4, Frame_9, UICorner_11, Copied_Key_Linkvertise_Link, Activated_5, Frame_10, UICorner_12, Copied_Key_Work_Ink_Link, Activated_6, Frame_11, UICorner_13, Copied_Discord_Link, Activated_7, UserId, Request_Result, r957;
pcall(function(p1_74, p2_74, a_74, b_74, c_74)
    LocalPlayer = game:GetService("Players").LocalPlayer;
    game:GetService("RunService");
    TweenService = game:GetService("TweenService");
    UserInputService = game:GetService("UserInputService");
    FromRGB = Color3.fromRGB;
    R11_Result = FromRGB(222, 9, 231);
    pcall(function(p1_3, p2_3, a_3, b_3, c_3)
        pcall(function(a_2, b_2, c_2, ...)
            pcall(function(p1, p2, a, b, c)
                isfile"keysystem_key.txt";
                Keysystem_Key_Txt = readfile"keysystem_key.txt";
                return Keysystem_Key_Txt;
            end);
            return Keysystem_Key_Txt;
        end);
        return Keysystem_Key_Txt;
    end);
    pcall(function(p1_73, p2_73, a_73, b_73, c_73)
        pcall(function(a_5, b_5, c_5, ...)
            pcall(function(p1_4, p2_4, a_4, b_4, c_4)
                Hui_Result = gethui();
                Hui_Result:FindFirstChild("TokyoKeySystem");
                Hui_Result.TokyoKeySystem:Destroy();
                game:GetService("CoreGui");
                Hui_Result:FindFirstChild("TokyoKeySystem");
                game:GetService("CoreGui");
                Hui_Result.TokyoKeySystem:Destroy();
                LocalPlayer:FindFirstChild("PlayerGui");
                PlayerGui = LocalPlayer.PlayerGui;
                PlayerGui:FindFirstChild("TokyoKeySystem");
                PlayerGui.TokyoKeySystem:Destroy();
            end);
        end);
        local _ = Enum.ZIndexBehavior.Sibling;
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            TokyoKeySystem_4 = Instance.new"ScreenGui";
            TokyoKeySystem_4.ResetOnSpawn = false;
            TokyoKeySystem_4.Name = "TokyoKeySystem";
            TokyoKeySystem_4.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
            return TokyoKeySystem_4;
        end);
        pcall(function(a_8, b_8, c_8, ...)
            pcall(function(p1_7, p2_7, a_7, b_7, c_7)
                TokyoKeySystem_4.Parent = gethui();
            end);
        end);
        local _ = TokyoKeySystem_4 == workspace.CurrentCamera;
        local _ = TokyoKeySystem_4 == workspace;
        local _ = TokyoKeySystem_4 == LocalPlayer;
        local _ = workspace.CurrentCamera.ViewportSize;
        UDim2_New = UDim2.new;
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            DropShadowHolder = Instance.new"Frame";
            DropShadowHolder.BackgroundTransparency = 1;
            DropShadowHolder.Position = UDim2_New(0.5, -220, 0.5, -155);
            DropShadowHolder.Name = "DropShadowHolder";
            DropShadowHolder.ZIndex = 0;
            DropShadowHolder.BorderSizePixel = 0;
            DropShadowHolder.Size = UDim2_New(0, 440, 0, 310);
            DropShadowHolder.Parent = TokyoKeySystem_4;
            return DropShadowHolder;
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            UIScale = Instance.new"UIScale";
            UIScale.Scale = 1;
            UIScale.Parent = DropShadowHolder;
            return UIScale;
        end);
        Vector2_New = Vector2.new;
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            ImageLabel = Instance.new"ImageLabel";
            ImageLabel.ImageColor3 = FromRGB(0, 0, 0);
            ImageLabel.ScaleType = Hui_Result.Slice;
            ImageLabel.ImageTransparency = 0.4;
            ImageLabel.AnchorPoint = Vector2_New(0.5, 0.5);
            ImageLabel.Image = "rbxassetid://6015897843";
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.Position = UDim2_New(0.5, 0, 0.5, 0);
            ImageLabel.ZIndex = 0;
            ImageLabel.Size = UDim2_New(1, 40, 1, 40);
            ImageLabel.SliceCenter = Rect.new(49, 49, 450, 450);
            ImageLabel.Parent = DropShadowHolder;
            return ImageLabel;
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            Frame = Instance.new"Frame";
            Frame.AnchorPoint = Vector2_New(0.5, 0.5);
            Frame.BackgroundTransparency = 0.05;
            Frame.Position = UDim2_New(0.5, 0, 0.5, 0);
            Frame.ClipsDescendants = true;
            Frame.Size = UDim2_New(1, 0, 1, 0);
            Frame.BorderSizePixel = 0;
            Frame.BackgroundColor3 = FromRGB(15, 12, 15);
            Frame.Parent = DropShadowHolder;
            return Frame;
        end);
        UDim_New = UDim.new;
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            UICorner = Instance.new"UICorner";
            UICorner.CornerRadius = UDim_New(0, 12);
            UICorner.Parent = Frame;
            return UICorner;
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            UIStroke = Instance.new"UIStroke";
            UIStroke.Thickness = 1.2;
            UIStroke.Transparency = 0.6;
            UIStroke.ApplyStrokeMode = Hui_Result.Border;
            UIStroke.Color = R11_Result;
            UIStroke.Parent = Frame;
            return UIStroke;
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            UIScale_2 = Instance.new"UIScale";
            UIScale_2.Scale = 0.85;
            UIScale_2.Parent = Frame;
            return UIScale_2;
        end);
        task.defer(function(a_160, b_160, c_160, ...)
            pcall(function(p1_161, p2_161, a_161, b_161, c_161)
                Hui_Result.Play(
                    TweenService:Create(UIScale_2, r548(0.35, Hui_Result.Back, Hui_Result.Out), {
                        ["Scale"] = 1
                    })
                );
            end);
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            Frame_2 = Instance.new"Frame";
            Frame_2.BackgroundTransparency = 1;
            Frame_2.Size = UDim2_New(1, 0, 0, 40);
            Frame_2.Parent = Frame;
            return Frame_2;
        end);
        pcall(function(p1_17, p2_17, a_17, b_17, c_17)
            Frame_2.InputBegan:Connect(function(a_74, b_74, c_74, ...)
                pcall(function(p1_75, p2_75, a_75, b_75, c_75)
                    UserInputType = Hui_Result.UserInputType;
                    local _ = UserInputType == Hui_Result.MouseButton1;
                    local _ = UserInputType == Hui_Result.Touch;
                end);
            end);
            Frame_2.InputChanged:Connect(function(a_76, b_76, c_76, ...) end);
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            ImageLabel_2 = Instance.new"ImageLabel";
            ImageLabel_2.AnchorPoint = Vector2_New(0, 0.5);
            ImageLabel_2.ScaleType = Hui_Result.Fit;
            ImageLabel_2.BackgroundTransparency = 1;
            ImageLabel_2.Position = UDim2_New(0, 20, 0.5, 0);
            ImageLabel_2.ImageColor3 = R11_Result;
            ImageLabel_2.Image = "rbxassetid://91570350247074";
            ImageLabel_2.Size = UDim2_New(0, 16, 0, 16);
            ImageLabel_2.Parent = Frame_2;
            return ImageLabel_2;
        end);
        Font_New = Font.new;
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            KEY_SYSTEM = Instance.new"TextLabel";
            KEY_SYSTEM.FontFace = Font_New("rbxasset://fonts/families/GothamSSm.json", Hui_Result.Heavy, Hui_Result.Normal);
            KEY_SYSTEM.TextColor3 = R11_Result;
            KEY_SYSTEM.Text = "KEY SYSTEM";
            KEY_SYSTEM.TextStrokeTransparency = 1;
            KEY_SYSTEM.BackgroundTransparency = 1;
            KEY_SYSTEM.TextXAlignment = Hui_Result.Left;
            KEY_SYSTEM.Position = UDim2_New(0, 44, 0, 0);
            KEY_SYSTEM.TextSize = 11;
            KEY_SYSTEM.Size = UDim2_New(1, -44, 1, 0);
            KEY_SYSTEM.Parent = Frame_2;
            return KEY_SYSTEM;
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            Frame_3 = Instance.new"Frame";
            Frame_3.Size = UDim2_New(0, 24, 0, 24);
            Frame_3.Position = UDim2_New(1, -38, 0.5, -12);
            Frame_3.BackgroundTransparency = 0.85;
            Frame_3.BackgroundColor3 = R11_Result;
            Frame_3.Parent = Frame_2;
            return Frame_3;
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            UICorner_2 = Instance.new"UICorner";
            UICorner_2.CornerRadius = UDim_New(0, 6);
            UICorner_2.Parent = Frame_3;
            return UICorner_2;
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            X = Instance.new"TextButton";
            X.FontFace = Font_New("rbxasset://fonts/families/GothamSSm.json", Hui_Result.Bold, Hui_Result.Normal);
            X.BackgroundTransparency = 1;
            X.TextColor3 = FromRGB(180, 150, 180);
            X.Size = UDim2_New(1, 0, 1, 0);
            X.Text = "X";
            X.TextSize = 11;
            X.TextStrokeTransparency = 1;
            X.Parent = Frame_3;
            return X;
        end);
        X.Activated:Connect(function(a_76, b_76, c_76, ...)
            pcall(function(p1_77, p2_77, a_77, b_77, c_77)
                TokyoKeySystem_4:Destroy();
                local _ = TokyoKeySystem_4 == workspace.CurrentCamera;
                local _ = TokyoKeySystem_4 == workspace;
                local _ = TokyoKeySystem_4 == LocalPlayer;
            end);
        end);
        pcall(function(p1_24, p2_24, a_24, b_24, c_24)
            pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                UIScale_3 = Instance.new"UIScale";
                UIScale_3.Scale = 1;
                UIScale_3.Parent = X;
                return UIScale_3;
            end);
            X.MouseButton1Down:Connect(function(a_78, b_78, c_78, ...)
                pcall(function(p1_79, p2_79, a_79, b_79, c_79)
                    r548 = TweenInfo.new;
                    Hui_Result.Play(
                        TweenService:Create(UIScale_3, r548(0.1, Hui_Result.Quad, Hui_Result.Out), {
                            ["Scale"] = 0.95
                        })
                    );
                end);
            end);
            X.MouseButton1Up:Connect(function(a_80, b_80, c_80, ...)
                pcall(function(p1_81, p2_81, a_81, b_81, c_81)
                    Hui_Result.Play(
                        TweenService:Create(UIScale_3, r548(0.1, Hui_Result.Back, Hui_Result.Out), {
                            ["Scale"] = 1
                        })
                    );
                end);
            end);
            X.MouseLeave:Connect(function(a_82, b_82, c_82, ...)
                pcall(function(p1_83, p2_83, a_83, b_83, c_83)
                    Hui_Result.Play(
                        TweenService:Create(UIScale_3, r548(0.1, Hui_Result.Quad, Hui_Result.Out), {
                            ["Scale"] = 1
                        })
                    );
                end);
            end);
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            Welcome_To_The = Instance.new"TextLabel";
            Welcome_To_The.FontFace = Font_New("rbxasset://fonts/families/GothamSSm.json", Hui_Result.Bold, Hui_Result.Normal);
            Welcome_To_The.TextColor3 = FromRGB(255, 255, 255);
            Welcome_To_The.Text = "Welcome to The,";
            Welcome_To_The.TextStrokeTransparency = 1;
            Welcome_To_The.BackgroundTransparency = 1;
            Welcome_To_The.TextXAlignment = Hui_Result.Left;
            Welcome_To_The.Position = UDim2_New(0, 20, 0, 40);
            Welcome_To_The.TextSize = 18;
            Welcome_To_The.Size = UDim2_New(1, -40, 0, 20);
            Welcome_To_The.Parent = Frame;
            return Welcome_To_The;
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            Tokyo_Hub = Instance.new"TextLabel";
            Tokyo_Hub.FontFace = Font_New("rbxasset://fonts/families/GothamSSm.json", Hui_Result.Heavy, Hui_Result.Normal);
            Tokyo_Hub.TextColor3 = R11_Result;
            Tokyo_Hub.Text = "Tokyo Hub";
            Tokyo_Hub.TextStrokeTransparency = 1;
            Tokyo_Hub.BackgroundTransparency = 1;
            Tokyo_Hub.TextXAlignment = Hui_Result.Left;
            Tokyo_Hub.Position = UDim2_New(0, 20, 0, 60);
            Tokyo_Hub.TextSize = 24;
            Tokyo_Hub.Size = UDim2_New(1, -40, 0, 24);
            Tokyo_Hub.Parent = Frame;
            return Tokyo_Hub;
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            Paste = Instance.new"TextButton";
            Paste.FontFace = Font_New("rbxasset://fonts/families/GothamSSm.json", Hui_Result.Bold, Hui_Result.Normal);
            Paste.TextColor3 = FromRGB(255, 255, 255);
            Paste.Text = "Paste";
            Paste.TextStrokeTransparency = 1;
            Paste.BackgroundTransparency = 0.9;
            Paste.Position = UDim2_New(0, 20, 0, 96);
            Paste.Size = UDim2_New(0, 60, 0, 36);
            Paste.TextSize = 12;
            Paste.BackgroundColor3 = R11_Result;
            Paste.Parent = Frame;
            return Paste;
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            UICorner_3 = Instance.new"UICorner";
            UICorner_3.CornerRadius = UDim_New(0, 8);
            UICorner_3.Parent = Paste;
            return UICorner_3;
        end);
        pcall(function(p1_24, p2_24, a_24, b_24, c_24)
            pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                UIScale_4 = Instance.new"UIScale";
                UIScale_4.Scale = 1;
                UIScale_4.Parent = Paste;
                return UIScale_4;
            end);
            Paste.MouseButton1Down:Connect(function(a_84, b_84, c_84, ...)
                pcall(function(p1_85, p2_85, a_85, b_85, c_85)
                    Hui_Result.Play(
                        TweenService:Create(UIScale_4, r548(0.1, Hui_Result.Quad, Hui_Result.Out), {
                            ["Scale"] = 0.95
                        })
                    );
                end);
            end);
            Paste.MouseButton1Up:Connect(function(a_86, b_86, c_86, ...)
                pcall(function(p1_87, p2_87, a_87, b_87, c_87)
                    Hui_Result.Play(
                        TweenService:Create(UIScale_4, r548(0.1, Hui_Result.Back, Hui_Result.Out), {
                            ["Scale"] = 1
                        })
                    );
                end);
            end);
            Paste.MouseLeave:Connect(function(a_88, b_88, c_88, ...)
                pcall(function(p1_89, p2_89, a_89, b_89, c_89)
                    Hui_Result.Play(
                        TweenService:Create(UIScale_4, r548(0.1, Hui_Result.Quad, Hui_Result.Out), {
                            ["Scale"] = 1
                        })
                    );
                end);
            end);
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            TextBox = Instance.new"TextBox";
            TextBox.FontFace = Font_New("rbxasset://fonts/families/GothamSSm.json", Hui_Result.Medium, Hui_Result.Normal);
            TextBox.TextColor3 = FromRGB(255, 255, 255);
            TextBox.Text = Keysystem_Key_Txt;
            TextBox.ClearTextOnFocus = false;
            TextBox.TextStrokeTransparency = 1;
            TextBox.Size = UDim2_New(1, -108, 0, 36);
            TextBox.Position = UDim2_New(0, 88, 0, 96);
            TextBox.BackgroundTransparency = 0.9;
            TextBox.PlaceholderColor3 = FromRGB(150, 150, 150);
            TextBox.TextXAlignment = Hui_Result.Left;
            TextBox.PlaceholderText = "Enter your key here...";
            TextBox.TextSize = 12;
            TextBox.BackgroundColor3 = R11_Result;
            TextBox.Parent = Frame;
            return TextBox;
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            UICorner_4 = Instance.new"UICorner";
            UICorner_4.CornerRadius = UDim_New(0, 8);
            UICorner_4.Parent = TextBox;
            return UICorner_4;
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            UIStroke_2 = Instance.new"UIStroke";
            UIStroke_2.Thickness = 1;
            UIStroke_2.Transparency = 0.4;
            UIStroke_2.ApplyStrokeMode = Hui_Result.Border;
            UIStroke_2.Color = R11_Result;
            UIStroke_2.Parent = TextBox;
            return UIStroke_2;
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            UIPadding = Instance.new"UIPadding";
            UIPadding.PaddingLeft = UDim_New(0, 12);
            UIPadding.Parent = TextBox;
            return UIPadding;
        end);
        Paste.Activated:Connect(function(a_90, b_90, c_90, ...)
            pcall(function(p1_93, p2_93, a_93, b_93, c_93)
                pcall(function(a_92, b_92, c_92, ...)
                    pcall(function(p1_91, p2_91, a_91, b_91, c_91)
                        getfenv().getclipboard();
                    end);
                end);
            end);
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            Submit_Key = Instance.new"TextButton";
            Submit_Key.FontFace = Font_New("rbxasset://fonts/families/GothamSSm.json", Hui_Result.Bold, Hui_Result.Normal);
            Submit_Key.TextColor3 = FromRGB(255, 255, 255);
            Submit_Key.Text = "Submit Key >";
            Submit_Key.TextStrokeTransparency = 1;
            Submit_Key.BackgroundTransparency = 0.75;
            Submit_Key.Position = UDim2_New(0, 20, 0, 142);
            Submit_Key.Size = UDim2_New(1, -40, 0, 36);
            Submit_Key.TextSize = 14;
            Submit_Key.BackgroundColor3 = R11_Result;
            Submit_Key.Parent = Frame;
            return Submit_Key;
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            UICorner_5 = Instance.new"UICorner";
            UICorner_5.CornerRadius = UDim_New(0, 8);
            UICorner_5.Parent = Submit_Key;
            return UICorner_5;
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            UIStroke_3 = Instance.new"UIStroke";
            UIStroke_3.Thickness = 1.2;
            UIStroke_3.Transparency = 0.1;
            UIStroke_3.ApplyStrokeMode = Hui_Result.Border;
            UIStroke_3.Color = R11_Result;
            UIStroke_3.Parent = Submit_Key;
            return UIStroke_3;
        end);
        pcall(function(p1_24, p2_24, a_24, b_24, c_24)
            pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                UIScale_5 = Instance.new"UIScale";
                UIScale_5.Scale = 1;
                UIScale_5.Parent = Submit_Key;
                return UIScale_5;
            end);
            Submit_Key.MouseButton1Down:Connect(function(a_94, b_94, c_94, ...)
                pcall(function(p1_95, p2_95, a_95, b_95, c_95)
                    Hui_Result.Play(
                        TweenService:Create(UIScale_5, r548(0.1, Hui_Result.Quad, Hui_Result.Out), {
                            ["Scale"] = 0.95
                        })
                    );
                end);
            end);
            Submit_Key.MouseButton1Up:Connect(function(a_96, b_96, c_96, ...)
                pcall(function(p1_97, p2_97, a_97, b_97, c_97)
                    Hui_Result.Play(
                        TweenService:Create(UIScale_5, r548(0.1, Hui_Result.Back, Hui_Result.Out), {
                            ["Scale"] = 1
                        })
                    );
                end);
            end);
            Submit_Key.MouseLeave:Connect(function(a_98, b_98, c_98, ...)
                pcall(function(p1_99, p2_99, a_99, b_99, c_99)
                    Hui_Result.Play(
                        TweenService:Create(UIScale_5, r548(0.1, Hui_Result.Quad, Hui_Result.Out), {
                            ["Scale"] = 1
                        })
                    );
                end);
            end);
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            TextButton = Instance.new"TextButton";
            TextButton.FontFace = Font_New("rbxasset://fonts/families/GothamSSm.json", Hui_Result.Medium, Hui_Result.Normal);
            TextButton.TextColor3 = FromRGB(130, 120, 140);
            TextButton.Text = "Need support? <b><font color=\"#5865F2\">Join the Discord<b>";
            TextButton.TextStrokeTransparency = 1;
            TextButton.BackgroundTransparency = 1;
            TextButton.Position = UDim2_New(0, 0, 0, 188);
            TextButton.RichText = true;
            TextButton.TextSize = 11;
            TextButton.Size = UDim2_New(1, 0, 0, 20);
            TextButton.Parent = Frame;
            return TextButton;
        end);
        pcall(function(p1_24, p2_24, a_24, b_24, c_24)
            pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                UIScale_6 = Instance.new"UIScale";
                UIScale_6.Scale = 1;
                UIScale_6.Parent = TextButton;
                return UIScale_6;
            end);
            TextButton.MouseButton1Down:Connect(function(a_100, b_100, c_100, ...)
                pcall(function(p1_101, p2_101, a_101, b_101, c_101)
                    Hui_Result.Play(
                        TweenService:Create(UIScale_6, r548(0.1, Hui_Result.Quad, Hui_Result.Out), {
                            ["Scale"] = 0.95
                        })
                    );
                end);
            end);
            TextButton.MouseButton1Up:Connect(function(a_102, b_102, c_102, ...)
                pcall(function(p1_103, p2_103, a_103, b_103, c_103)
                    Hui_Result.Play(
                        TweenService:Create(UIScale_6, r548(0.1, Hui_Result.Back, Hui_Result.Out), {
                            ["Scale"] = 1
                        })
                    );
                end);
            end);
            TextButton.MouseLeave:Connect(function(a_104, b_104, c_104, ...)
                pcall(function(p1_105, p2_105, a_105, b_105, c_105)
                    Hui_Result.Play(
                        TweenService:Create(UIScale_6, r548(0.1, Hui_Result.Quad, Hui_Result.Out), {
                            ["Scale"] = 1
                        })
                    );
                end);
            end);
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            Frame_4 = Instance.new"Frame";
            Frame_4.BackgroundTransparency = 0.9;
            Frame_4.Position = UDim2_New(0, 20, 0, 218);
            Frame_4.Size = UDim2_New(1, -40, 0, 1);
            Frame_4.BorderSizePixel = 0;
            Frame_4.BackgroundColor3 = FromRGB(255, 255, 255);
            Frame_4.Parent = Frame;
            return Frame_4;
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            Frame_5 = Instance.new"Frame";
            Frame_5.Position = UDim2_New(0, 20, 0, 230);
            Frame_5.BackgroundTransparency = 1;
            Frame_5.Size = UDim2_New(1, -40, 0, 30);
            Frame_5.Parent = Frame;
            return Frame_5;
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            UIListLayout = Instance.new"UIListLayout";
            UIListLayout.FillDirection = Hui_Result.Horizontal;
            UIListLayout.HorizontalAlignment = Hui_Result.Center;
            UIListLayout.Padding = UDim_New(0, 8);
            UIListLayout.Parent = Frame_5;
            return UIListLayout;
        end);
        pcall(function(p1_52, p2_52, a_52, b_52, c_52)
            pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                LootLabs = Instance.new"TextButton";
                LootLabs.Size = UDim2_New(0, 128, 1, 0);
                LootLabs.FontFace = Font_New("rbxasset://fonts/families/GothamSSm.json", Hui_Result.Bold, Hui_Result.Normal);
                LootLabs.BackgroundTransparency = 0.9;
                LootLabs.TextColor3 = FromRGB(230, 230, 230);
                LootLabs.BackgroundColor3 = R11_Result;
                LootLabs.Text = "      LootLabs";
                LootLabs.TextSize = 14;
                LootLabs.TextStrokeTransparency = 1;
                LootLabs.Parent = Frame_5;
                return LootLabs;
            end);
            pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                UICorner_6 = Instance.new"UICorner";
                UICorner_6.CornerRadius = UDim_New(0, 8);
                UICorner_6.Parent = LootLabs;
                return UICorner_6;
            end);
            pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                UIStroke_4 = Instance.new"UIStroke";
                UIStroke_4.Thickness = 1;
                UIStroke_4.Transparency = 0.5;
                UIStroke_4.ApplyStrokeMode = Hui_Result.Border;
                UIStroke_4.Color = R11_Result;
                UIStroke_4.Parent = LootLabs;
                return UIStroke_4;
            end);
            pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                ImageLabel_3 = Instance.new"ImageLabel";
                ImageLabel_3.ImageColor3 = FromRGB(255, 255, 255);
                ImageLabel_3.Image = "rbxassetid://71743559500662";
                ImageLabel_3.BackgroundTransparency = 1;
                ImageLabel_3.Position = UDim2_New(0, 12, 0.5, -8);
                ImageLabel_3.Size = UDim2_New(0, 16, 0, 16);
                ImageLabel_3.Parent = LootLabs;
                return ImageLabel_3;
            end);
            pcall(function(p1_24, p2_24, a_24, b_24, c_24)
                pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                    UIScale_7 = Instance.new"UIScale";
                    UIScale_7.Scale = 1;
                    UIScale_7.Parent = LootLabs;
                    return UIScale_7;
                end);
                LootLabs.MouseButton1Down:Connect(function(a_106, b_106, c_106, ...)
                    pcall(function(p1_107, p2_107, a_107, b_107, c_107)
                        Hui_Result.Play(
                            TweenService:Create(UIScale_7, r548(0.1, Hui_Result.Quad, Hui_Result.Out), {
                                ["Scale"] = 0.95
                            })
                        );
                    end);
                end);
                LootLabs.MouseButton1Up:Connect(function(a_108, b_108, c_108, ...)
                    pcall(function(p1_109, p2_109, a_109, b_109, c_109)
                        Hui_Result.Play(
                            TweenService:Create(UIScale_7, r548(0.1, Hui_Result.Back, Hui_Result.Out), {
                                ["Scale"] = 1
                            })
                        );
                    end);
                end);
                LootLabs.MouseLeave:Connect(function(a_110, b_110, c_110, ...)
                    pcall(function(p1_111, p2_111, a_111, b_111, c_111)
                        Hui_Result.Play(
                            TweenService:Create(UIScale_7, r548(0.1, Hui_Result.Quad, Hui_Result.Out), {
                                ["Scale"] = 1
                            })
                        );
                    end);
                end);
            end);
            return LootLabs;
        end);
        pcall(function(p1_52, p2_52, a_52, b_52, c_52)
            pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                Linkvertise = Instance.new"TextButton";
                Linkvertise.Size = UDim2_New(0, 128, 1, 0);
                Linkvertise.FontFace = Font_New("rbxasset://fonts/families/GothamSSm.json", Hui_Result.Bold, Hui_Result.Normal);
                Linkvertise.BackgroundTransparency = 0.9;
                Linkvertise.TextColor3 = FromRGB(230, 230, 230);
                Linkvertise.BackgroundColor3 = R11_Result;
                Linkvertise.Text = "      Linkvertise";
                Linkvertise.TextSize = 14;
                Linkvertise.TextStrokeTransparency = 1;
                Linkvertise.Parent = Frame_5;
                return Linkvertise;
            end);
            pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                UICorner_7 = Instance.new"UICorner";
                UICorner_7.CornerRadius = UDim_New(0, 8);
                UICorner_7.Parent = Linkvertise;
                return UICorner_7;
            end);
            pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                UIStroke_5 = Instance.new"UIStroke";
                UIStroke_5.Thickness = 1;
                UIStroke_5.Transparency = 0.5;
                UIStroke_5.ApplyStrokeMode = Hui_Result.Border;
                UIStroke_5.Color = R11_Result;
                UIStroke_5.Parent = Linkvertise;
                return UIStroke_5;
            end);
            pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                ImageLabel_4 = Instance.new"ImageLabel";
                ImageLabel_4.ImageColor3 = FromRGB(255, 255, 255);
                ImageLabel_4.Image = "rbxassetid://111199231561006";
                ImageLabel_4.BackgroundTransparency = 1;
                ImageLabel_4.Position = UDim2_New(0, 12, 0.5, -8);
                ImageLabel_4.Size = UDim2_New(0, 16, 0, 16);
                ImageLabel_4.Parent = Linkvertise;
                return ImageLabel_4;
            end);
            pcall(function(p1_24, p2_24, a_24, b_24, c_24)
                pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                    UIScale_8 = Instance.new"UIScale";
                    UIScale_8.Scale = 1;
                    UIScale_8.Parent = Linkvertise;
                    return UIScale_8;
                end);
                Linkvertise.MouseButton1Down:Connect(function(a_112, b_112, c_112, ...)
                    pcall(function(p1_113, p2_113, a_113, b_113, c_113)
                        Hui_Result.Play(
                            TweenService:Create(UIScale_8, r548(0.1, Hui_Result.Quad, Hui_Result.Out), {
                                ["Scale"] = 0.95
                            })
                        );
                    end);
                end);
                Linkvertise.MouseButton1Up:Connect(function(a_114, b_114, c_114, ...)
                    pcall(function(p1_115, p2_115, a_115, b_115, c_115)
                        Hui_Result.Play(
                            TweenService:Create(UIScale_8, r548(0.1, Hui_Result.Back, Hui_Result.Out), {
                                ["Scale"] = 1
                            })
                        );
                    end);
                end);
                Linkvertise.MouseLeave:Connect(function(a_116, b_116, c_116, ...)
                    pcall(function(p1_117, p2_117, a_117, b_117, c_117)
                        Hui_Result.Play(
                            TweenService:Create(UIScale_8, r548(0.1, Hui_Result.Quad, Hui_Result.Out), {
                                ["Scale"] = 1
                            })
                        );
                    end);
                end);
            end);
            return Linkvertise;
        end);
        pcall(function(p1_52, p2_52, a_52, b_52, c_52)
            pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                Work_Ink = Instance.new"TextButton";
                Work_Ink.Size = UDim2_New(0, 128, 1, 0);
                Work_Ink.FontFace = Font_New("rbxasset://fonts/families/GothamSSm.json", Hui_Result.Bold, Hui_Result.Normal);
                Work_Ink.BackgroundTransparency = 0.9;
                Work_Ink.TextColor3 = FromRGB(230, 230, 230);
                Work_Ink.BackgroundColor3 = R11_Result;
                Work_Ink.Text = "      Work.ink";
                Work_Ink.TextSize = 14;
                Work_Ink.TextStrokeTransparency = 1;
                Work_Ink.Parent = Frame_5;
                return Work_Ink;
            end);
            pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                UICorner_8 = Instance.new"UICorner";
                UICorner_8.CornerRadius = UDim_New(0, 8);
                UICorner_8.Parent = Work_Ink;
                return UICorner_8;
            end);
            pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                UIStroke_6 = Instance.new"UIStroke";
                UIStroke_6.Thickness = 1;
                UIStroke_6.Transparency = 0.5;
                UIStroke_6.ApplyStrokeMode = Hui_Result.Border;
                UIStroke_6.Color = R11_Result;
                UIStroke_6.Parent = Work_Ink;
                return UIStroke_6;
            end);
            pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                ImageLabel_5 = Instance.new"ImageLabel";
                ImageLabel_5.ImageColor3 = FromRGB(255, 255, 255);
                ImageLabel_5.Image = "rbxassetid://112984444145512";
                ImageLabel_5.BackgroundTransparency = 1;
                ImageLabel_5.Position = UDim2_New(0, 12, 0.5, -8);
                ImageLabel_5.Size = UDim2_New(0, 16, 0, 16);
                ImageLabel_5.Parent = Work_Ink;
                return ImageLabel_5;
            end);
            pcall(function(p1_24, p2_24, a_24, b_24, c_24)
                pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                    UIScale_9 = Instance.new"UIScale";
                    UIScale_9.Scale = 1;
                    UIScale_9.Parent = Work_Ink;
                    return UIScale_9;
                end);
                Work_Ink.MouseButton1Down:Connect(function(a_118, b_118, c_118, ...)
                    pcall(function(p1_119, p2_119, a_119, b_119, c_119)
                        Hui_Result.Play(
                            TweenService:Create(UIScale_9, r548(0.1, Hui_Result.Quad, Hui_Result.Out), {
                                ["Scale"] = 0.95
                            })
                        );
                    end);
                end);
                Work_Ink.MouseButton1Up:Connect(function(a_120, b_120, c_120, ...)
                    pcall(function(p1_121, p2_121, a_121, b_121, c_121)
                        Hui_Result.Play(
                            TweenService:Create(UIScale_9, r548(0.1, Hui_Result.Back, Hui_Result.Out), {
                                ["Scale"] = 1
                            })
                        );
                    end);
                end);
                Work_Ink.MouseLeave:Connect(function(a_122, b_122, c_122, ...)
                    pcall(function(p1_123, p2_123, a_123, b_123, c_123)
                        Hui_Result.Play(
                            TweenService:Create(UIScale_9, r548(0.1, Hui_Result.Quad, Hui_Result.Out), {
                                ["Scale"] = 1
                            })
                        );
                    end);
                end);
            end);
            return Work_Ink;
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            TextLabel = Instance.new"TextLabel";
            TextLabel.FontFace = Font_New("rbxasset://fonts/families/GothamSSm.json", Hui_Result.Medium, Hui_Result.Normal);
            TextLabel.TextColor3 = FromRGB(130, 130, 130);
            TextLabel.Text = "Enjoy keyless access every weekend.";
            TextLabel.TextStrokeTransparency = 1;
            TextLabel.BackgroundTransparency = 1;
            TextLabel.Position = UDim2_New(0, 46, 0, 276);
            TextLabel.TextXAlignment = Hui_Result.Left;
            TextLabel.TextSize = 10;
            TextLabel.Size = UDim2_New(1, -66, 0, 16);
            TextLabel.Parent = Frame;
            return TextLabel;
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            Frame_6 = Instance.new"Frame";
            Frame_6.Size = UDim2_New(0, 16, 0, 16);
            Frame_6.Position = UDim2_New(0, 20, 0, 276);
            Frame_6.BackgroundColor3 = FromRGB(200, 40, 40);
            Frame_6.Parent = Frame;
            return Frame_6;
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            UICorner_9 = Instance.new"UICorner";
            UICorner_9.CornerRadius = UDim_New(1, 0);
            UICorner_9.Parent = Frame_6;
            return UICorner_9;
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            TextLabel_2 = Instance.new"TextLabel";
            TextLabel_2.FontFace = Font_New("rbxasset://fonts/families/GothamSSm.json", Hui_Result.Bold, Hui_Result.Normal);
            TextLabel_2.BackgroundTransparency = 1;
            TextLabel_2.TextColor3 = FromRGB(255, 255, 255);
            TextLabel_2.Size = UDim2_New(1, 0, 1, 0);
            TextLabel_2.Text = "!";
            TextLabel_2.TextSize = 10;
            TextLabel_2.TextStrokeTransparency = 1;
            TextLabel_2.Parent = Frame_6;
            return TextLabel_2;
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            Frame_7 = Instance.new"Frame";
            Frame_7.AnchorPoint = Vector2_New(0, 1);
            Frame_7.BackgroundTransparency = 1;
            Frame_7.Position = UDim2_New(0, 0, 1, -12);
            Frame_7.ZIndex = 50;
            Frame_7.ClipsDescendants = false;
            Frame_7.Size = UDim2_New(1, 0, 0.5, 0);
            Frame_7.Parent = Frame;
            return Frame_7;
        end);
        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
            UIListLayout_2 = Instance.new"UIListLayout";
            UIListLayout_2.VerticalAlignment = Hui_Result.Bottom;
            UIListLayout_2.Padding = UDim_New(0, 6);
            UIListLayout_2.HorizontalAlignment = Hui_Result.Center;
            UIListLayout_2.SortOrder = Hui_Result.LayoutOrder;
            UIListLayout_2.Parent = Frame_7;
            return UIListLayout_2;
        end);
        LootLabs.Activated:Connect(function(a_124, b_124, c_124, ...)
            pcall(function(p1_130, p2_130, a_130, b_130, c_130)
                pcall(function(p1_129, p2_129, a_129, b_129, c_129)
                    setclipboard"https://(discord invite)";
                    pcall(function(p1_128, p2_128, a_128, b_128, c_128)
                        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                            Frame_8 = Instance.new"Frame";
                            Frame_8.BackgroundColor3 = FromRGB(10, 190, 90);
                            Frame_8.ZIndex = 50;
                            Frame_8.BackgroundTransparency = 1;
                            Frame_8.Size = UDim2_New(0, 210, 0, 26);
                            Frame_8.Parent = Frame_7;
                            return Frame_8;
                        end);
                        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                            UICorner_10 = Instance.new"UICorner";
                            UICorner_10.CornerRadius = UDim_New(1, 0);
                            UICorner_10.Parent = Frame_8;
                            return UICorner_10;
                        end);
                        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                            Copied_Key_LootLabs_Link = Instance.new"TextLabel";
                            Copied_Key_LootLabs_Link.FontFace = Font_New("rbxasset://fonts/families/GothamSSm.json", Hui_Result.Bold, Hui_Result.Normal);
                            Copied_Key_LootLabs_Link.TextColor3 = FromRGB(255, 255, 255);
                            Copied_Key_LootLabs_Link.TextTransparency = 1;
                            Copied_Key_LootLabs_Link.Text = "Copied Get Key LootLabs Link";
                            Copied_Key_LootLabs_Link.TextStrokeTransparency = 1;
                            Copied_Key_LootLabs_Link.BackgroundTransparency = 1;
                            Copied_Key_LootLabs_Link.ZIndex = 51;
                            Copied_Key_LootLabs_Link.TextSize = 10;
                            Copied_Key_LootLabs_Link.Size = UDim2_New(1, 0, 1, 0);
                            Copied_Key_LootLabs_Link.Parent = Frame_8;
                            return Copied_Key_LootLabs_Link;
                        end);
                        Hui_Result.Play(
                            TweenService:Create(Frame_8, r548(0.2), {
                                ["BackgroundTransparency"] = 0.25
                            })
                        );
                        Hui_Result.Play(
                            TweenService:Create(Copied_Key_LootLabs_Link, r548(0.2), {
                                ["TextTransparency"] = 0
                            })
                        );
                        task.delay(2.5, function(a_162, b_162, c_162, ...)
                            pcall(function(p1_163, p2_163, a_163, b_163, c_163)
                                Hui_Result.Play(
                                    TweenService:Create(Copied_Key_LootLabs_Link, r548(0.3), {
                                        ["TextTransparency"] = 1
                                    })
                                );
                                Hui_Result.Play(
                                    TweenService:Create(Frame_8, r548(0.3), {
                                        ["BackgroundTransparency"] = 1
                                    })
                                );
                                Hui_Result.Wait(Hui_Result.Completed);
                                local _ = Frame_8 == workspace.CurrentCamera;
                                local _ = Frame_8 == workspace;
                                local _ = Frame_8 == LocalPlayer;
                                Frame_8:Destroy();
                                local _ = Frame_8 == workspace.CurrentCamera;
                                local _ = Frame_8 == workspace;
                                local _ = Frame_8 == LocalPlayer;
                            end);
                        end);
                    end);
                end);
            end);
        end);
        Linkvertise.Activated:Connect(function(a_131, b_131, c_131, ...)
            pcall(function(p1_137, p2_137, a_137, b_137, c_137)
                pcall(function(p1_129, p2_129, a_129, b_129, c_129)
                    setclipboard"https://(discord invite)";
                    pcall(function(p1_128, p2_128, a_128, b_128, c_128)
                        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                            Frame_9 = Instance.new"Frame";
                            Frame_9.BackgroundColor3 = FromRGB(10, 190, 90);
                            Frame_9.ZIndex = 50;
                            Frame_9.BackgroundTransparency = 1;
                            Frame_9.Size = UDim2_New(0, 210, 0, 26);
                            Frame_9.Parent = Frame_7;
                            return Frame_9;
                        end);
                        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                            UICorner_11 = Instance.new"UICorner";
                            UICorner_11.CornerRadius = UDim_New(1, 0);
                            UICorner_11.Parent = Frame_9;
                            return UICorner_11;
                        end);
                        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                            Copied_Key_Linkvertise_Link = Instance.new"TextLabel";
                            Copied_Key_Linkvertise_Link.FontFace = Font_New("rbxasset://fonts/families/GothamSSm.json", Hui_Result.Bold, Hui_Result.Normal);
                            Copied_Key_Linkvertise_Link.TextColor3 = FromRGB(255, 255, 255);
                            Copied_Key_Linkvertise_Link.TextTransparency = 1;
                            Copied_Key_Linkvertise_Link.Text = "Copied Get Key Linkvertise Link";
                            Copied_Key_Linkvertise_Link.TextStrokeTransparency = 1;
                            Copied_Key_Linkvertise_Link.BackgroundTransparency = 1;
                            Copied_Key_Linkvertise_Link.ZIndex = 51;
                            Copied_Key_Linkvertise_Link.TextSize = 10;
                            Copied_Key_Linkvertise_Link.Size = UDim2_New(1, 0, 1, 0);
                            Copied_Key_Linkvertise_Link.Parent = Frame_9;
                            return Copied_Key_Linkvertise_Link;
                        end);
                        Hui_Result.Play(
                            TweenService:Create(Frame_9, r548(0.2), {
                                ["BackgroundTransparency"] = 0.25
                            })
                        );
                        Hui_Result.Play(
                            TweenService:Create(Copied_Key_Linkvertise_Link, r548(0.2), {
                                ["TextTransparency"] = 0
                            })
                        );
                        task.delay(2.5, function(a_164, b_164, c_164, ...)
                            pcall(function(p1_165, p2_165, a_165, b_165, c_165)
                                Hui_Result.Play(
                                    TweenService:Create(Copied_Key_Linkvertise_Link, r548(0.3), {
                                        ["TextTransparency"] = 1
                                    })
                                );
                                Hui_Result.Play(
                                    TweenService:Create(Frame_9, r548(0.3), {
                                        ["BackgroundTransparency"] = 1
                                    })
                                );
                                Hui_Result.Wait(Hui_Result.Completed);
                                local _ = Frame_9 == workspace.CurrentCamera;
                                local _ = Frame_9 == workspace;
                                local _ = Frame_9 == LocalPlayer;
                                Frame_9:Destroy();
                                local _ = Frame_9 == workspace.CurrentCamera;
                                local _ = Frame_9 == workspace;
                                local _ = Frame_9 == LocalPlayer;
                            end);
                        end);
                    end);
                end);
            end);
        end);
        Work_Ink.Activated:Connect(function(a_138, b_138, c_138, ...)
            pcall(function(p1_144, p2_144, a_144, b_144, c_144)
                pcall(function(p1_129, p2_129, a_129, b_129, c_129)
                    setclipboard"https://(discord invite)";
                    pcall(function(p1_128, p2_128, a_128, b_128, c_128)
                        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                            Frame_10 = Instance.new"Frame";
                            Frame_10.BackgroundColor3 = FromRGB(10, 190, 90);
                            Frame_10.ZIndex = 50;
                            Frame_10.BackgroundTransparency = 1;
                            Frame_10.Size = UDim2_New(0, 210, 0, 26);
                            Frame_10.Parent = Frame_7;
                            return Frame_10;
                        end);
                        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                            UICorner_12 = Instance.new"UICorner";
                            UICorner_12.CornerRadius = UDim_New(1, 0);
                            UICorner_12.Parent = Frame_10;
                            return UICorner_12;
                        end);
                        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                            Copied_Key_Work_Ink_Link = Instance.new"TextLabel";
                            Copied_Key_Work_Ink_Link.FontFace = Font_New("rbxasset://fonts/families/GothamSSm.json", Hui_Result.Bold, Hui_Result.Normal);
                            Copied_Key_Work_Ink_Link.TextColor3 = FromRGB(255, 255, 255);
                            Copied_Key_Work_Ink_Link.TextTransparency = 1;
                            Copied_Key_Work_Ink_Link.Text = "Copied Get Key Work.ink Link";
                            Copied_Key_Work_Ink_Link.TextStrokeTransparency = 1;
                            Copied_Key_Work_Ink_Link.BackgroundTransparency = 1;
                            Copied_Key_Work_Ink_Link.ZIndex = 51;
                            Copied_Key_Work_Ink_Link.TextSize = 10;
                            Copied_Key_Work_Ink_Link.Size = UDim2_New(1, 0, 1, 0);
                            Copied_Key_Work_Ink_Link.Parent = Frame_10;
                            return Copied_Key_Work_Ink_Link;
                        end);
                        Hui_Result.Play(
                            TweenService:Create(Frame_10, r548(0.2), {
                                ["BackgroundTransparency"] = 0.25
                            })
                        );
                        Hui_Result.Play(
                            TweenService:Create(Copied_Key_Work_Ink_Link, r548(0.2), {
                                ["TextTransparency"] = 0
                            })
                        );
                        task.delay(2.5, function(a_166, b_166, c_166, ...)
                            pcall(function(p1_167, p2_167, a_167, b_167, c_167)
                                Hui_Result.Play(
                                    TweenService:Create(Copied_Key_Work_Ink_Link, r548(0.3), {
                                        ["TextTransparency"] = 1
                                    })
                                );
                                Hui_Result.Play(
                                    TweenService:Create(Frame_10, r548(0.3), {
                                        ["BackgroundTransparency"] = 1
                                    })
                                );
                                Hui_Result.Wait(Hui_Result.Completed);
                                local _ = Frame_10 == workspace.CurrentCamera;
                                local _ = Frame_10 == workspace;
                                local _ = Frame_10 == LocalPlayer;
                                Frame_10:Destroy();
                                local _ = Frame_10 == workspace.CurrentCamera;
                                local _ = Frame_10 == workspace;
                                local _ = Frame_10 == LocalPlayer;
                            end);
                        end);
                    end);
                end);
            end);
        end);
        TextButton.Activated:Connect(function(a_145, b_145, c_145, ...)
            pcall(function(p1_151, p2_151, a_151, b_151, c_151)
                pcall(function(p1_129, p2_129, a_129, b_129, c_129)
                    setclipboard"https://(discord invite)";
                    pcall(function(p1_128, p2_128, a_128, b_128, c_128)
                        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                            Frame_11 = Instance.new"Frame";
                            Frame_11.BackgroundColor3 = FromRGB(10, 190, 90);
                            Frame_11.ZIndex = 50;
                            Frame_11.BackgroundTransparency = 1;
                            Frame_11.Size = UDim2_New(0, 210, 0, 26);
                            Frame_11.Parent = Frame_7;
                            return Frame_11;
                        end);
                        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                            UICorner_13 = Instance.new"UICorner";
                            UICorner_13.CornerRadius = UDim_New(1, 0);
                            UICorner_13.Parent = Frame_11;
                            return UICorner_13;
                        end);
                        pcall(function(p1_6, p2_6, a_6, b_6, c_6)
                            Copied_Discord_Link = Instance.new"TextLabel";
                            Copied_Discord_Link.FontFace = Font_New("rbxasset://fonts/families/GothamSSm.json", Hui_Result.Bold, Hui_Result.Normal);
                            Copied_Discord_Link.TextColor3 = FromRGB(255, 255, 255);
                            Copied_Discord_Link.TextTransparency = 1;
                            Copied_Discord_Link.Text = "Copied Discord Link";
                            Copied_Discord_Link.TextStrokeTransparency = 1;
                            Copied_Discord_Link.BackgroundTransparency = 1;
                            Copied_Discord_Link.ZIndex = 51;
                            Copied_Discord_Link.TextSize = 10;
                            Copied_Discord_Link.Size = UDim2_New(1, 0, 1, 0);
                            Copied_Discord_Link.Parent = Frame_11;
                            return Copied_Discord_Link;
                        end);
                        Hui_Result.Play(
                            TweenService:Create(Frame_11, r548(0.2), {
                                ["BackgroundTransparency"] = 0.25
                            })
                        );
                        Hui_Result.Play(
                            TweenService:Create(Copied_Discord_Link, r548(0.2), {
                                ["TextTransparency"] = 0
                            })
                        );
                        task.delay(2.5, function(a_168, b_168, c_168, ...)
                            pcall(function(p1_169, p2_169, a_169, b_169, c_169)
                                Hui_Result.Play(
                                    TweenService:Create(Copied_Discord_Link, r548(0.3), {
                                        ["TextTransparency"] = 1
                                    })
                                );
                                Hui_Result.Play(
                                    TweenService:Create(Frame_11, r548(0.3), {
                                        ["BackgroundTransparency"] = 1
                                    })
                                );
                                Hui_Result.Wait(Hui_Result.Completed);
                                local _ = Frame_11 == workspace.CurrentCamera;
                                local _ = Frame_11 == workspace;
                                local _ = Frame_11 == LocalPlayer;
                                Frame_11:Destroy();
                                local _ = Frame_11 == workspace.CurrentCamera;
                                local _ = Frame_11 == workspace;
                                local _ = Frame_11 == LocalPlayer;
                            end);
                        end);
                    end);
                end);
            end);
        end);
        Submit_Key.Activated:Connect(function(a_152, b_152, c_152, ...)
            pcall(function(p1_159, p2_159, a_159, b_159, c_159)
                Hui_Result.match(TextBox.Text, "^%s*(.-)%s*$");
                Submit_Key.Text = "Checking...";
                Submit_Key.BackgroundTransparency = 0.5;
                pcall(function(p1_155, p2_155, a_155, b_155, c_155)
                    pcall(function(a_154, b_154, c_154, ...)
                        local success_124, r952 = pcall(function(p1_153, p2_153, a_153, b_153, c_153)
                            UserId = LocalPlayer.UserId;
                            tostring(UserId);
                            tostring(UserId);
                            tostring(game.PlaceId);
                            tostring(game.GameId);
                            game:GetService("HttpService"):JSONEncode({
                                ["hwid"] = "742103",
                                ["robloxDisplayName"] = LocalPlayer.DisplayName,
                                ["robloxName"] = LocalPlayer.Name,
                                ["robloxId"] = "742103",
                                ["placeId"] = "384947",
                                ["gameId"] = "272905"
                            });
                            Request_Result = request{
                                ["Body"] = "{\"gameId\":\"272905\",\"hwid\":\"742103\",\"placeId\":\"384947\",\"robloxDisplayName\":\"jdslydar\",\"robloxId\":\"742103\",\"robloxName\":\"Player\"}",
                                ["Url"] = "https://tokyo-private.vercel.app/api/ror",
                                ["Method"] = "POST",
                                ["Headers"] = {
                                    ["Content-Type"] = "application/json"
                                }
                            };
                            return Request_Result;
                        end);
                        return r952;
                    end);
                    r957 = "Server error (" .. (
                        tostring(Hui_Result.StatusCode) .. ")"
                    );
                    return false, r957;
                end);
                local _ = TokyoKeySystem_4 == workspace.CurrentCamera;
                local _ = TokyoKeySystem_4 == workspace;
                local _ = TokyoKeySystem_4 == LocalPlayer;
                UIStroke_3.Color = FromRGB(239, 68, 68);
                Submit_Key.BackgroundColor3 = FromRGB(239, 68, 68);
                Submit_Key.BackgroundTransparency = 0.5;
                Submit_Key.Text = r957;
                task.wait(1.5);
                UIStroke_3.Color = R11_Result;
                Submit_Key.BackgroundColor3 = R11_Result;
                Submit_Key.BackgroundTransparency = 0.75;
                Submit_Key.Text = "Submit Key >";
                pcall(function(p1_158, p2_158, a_158, b_158, c_158)
                    pcall(function(a_157, b_157, c_157, ...)
                        pcall(function(p1_156, p2_156, a_156, b_156, c_156)
                            isfile"keysystem_key.txt";
                            writefile("keysystem_key.txt", "");
                        end);
                    end);
                end);
            end);
        end);
    end);
end);
